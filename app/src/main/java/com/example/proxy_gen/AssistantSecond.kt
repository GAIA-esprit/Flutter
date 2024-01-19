import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.example.proxy_gen.R
import com.example.proxy_gen.bottom_sheet_layout
import com.google.android.material.bottomsheet.BottomSheetDialogFragment

class AssistantSecond : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_asistant_second, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Show the BottomSheetFragment when the AssistantSecond fragment is launched
        val bottomSheetFragment = bottom_sheet_layout()
        bottomSheetFragment.show(parentFragmentManager, bottomSheetFragment.tag)
    }
}
