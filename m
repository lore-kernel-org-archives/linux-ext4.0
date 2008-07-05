From: "Subrata Modak" <tosubrata-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Ext4 patches for the next merge window & Enhancements in
	2.6.25
Date: Sun, 6 Jul 2008 00:32:54 +0530
Message-ID: <bb33bcf20807051202s305d2c68oae814c2c54a82697@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2132454340=="
Cc: ltp-list <ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>,
	Andreas Dilger <adilger-xsfywfwIY+M@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Valerie Clement <valerie.clement-6ktuUTfB/bM@public.gmane.org>,
	"Jose R. Santos" <jrs-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>,
	Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Aneesh Kumar <aneesh.kumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Frederic Bohe <frederic.bohe-6ktuUTfB/bM@public.gmane.org>,
	Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
	Julia Lawall <julia-dAYI7NvHqcQ@public.gmane.org>,
	"Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
	Mingming Cao <cmm-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Alex Tomas <alex-KYPl3Ael/zSakBO8gow8eQ@public.gmane.org>,
	Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shen Feng <shen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
To: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <ltp-list-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ltp-list>,
	<mailto:ltp-list-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ltp-list>
List-Post: <mailto:ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ltp-list-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ltp-list>,
	<mailto:ltp-list-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: ltp-list-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: ltp-list-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

--===============2132454340==
Content-Type: multipart/alternative;
	boundary="----=_Part_11191_2166332.1215284574037"

------=_Part_11191_2166332.1215284574037
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Ted & Others,

EXT4 has seen major enhancements in 2.6.25 and i can see few more
enhancements for the next stable tree. I would like to know whether EXT4
team has developed organized/automated test suites also to test EXT4
features before releasing the patches to LKML. Apart from the normal
fallocate() syscall test cases in LTP, we do not have any specific test case
for the EXT4 file system. May i know if you have some thing to offer to LTP
(http://ltp.sourceforge.net/) under GPL, or, any future plans to develop
test cases as well.

Regards--
Subrata

On Sat, Jul 5, 2008 at 11:05 PM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:

> The following set of patches are being prepared for pushing to Linus
> during the next patch window.  Aside from a large number of cleanups
> the big new feature in this patchset is delayed allocation support.
>
> I've been running this patch series on my laptop for the past couple
> of days in production, and it's been working quite well for me.
>
>                                     - Ted
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards & Thanks--
Subrata

------=_Part_11191_2166332.1215284574037
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Ted &amp; Others,<br><br>EXT4 has seen major enhancements in 2.6.25 and i can see few more enhancements for the next stable tree. I would like to know whether EXT4 team has developed organized/automated test suites also to test EXT4 features before releasing the patches to LKML. Apart from the normal fallocate() syscall test cases in LTP, we do not have any specific test case for the EXT4 file system. May i know if you have some thing to offer to LTP (<a href="http://ltp.sourceforge.net/">http://ltp.sourceforge.net/</a>) under GPL, or, any future plans to develop test cases as well.<br>
<br>Regards--<br>Subrata<br><br><div class="gmail_quote">On Sat, Jul 5, 2008 at 11:05 PM, Theodore Ts&#39;o &lt;<a href="mailto:tytso-3s7WtUTddSA@public.gmane.org">tytso-3s7WtUTddSA@public.gmane.org</a>&gt; wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
The following set of patches are being prepared for pushing to Linus<br>
during the next patch window. &nbsp;Aside from a large number of cleanups<br>
the big new feature in this patchset is delayed allocation support.<br>
<br>
I&#39;ve been running this patch series on my laptop for the past couple<br>
of days in production, and it&#39;s been working quite well for me.<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; - Ted<br>
<font color="#888888"><br>
<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-kernel&quot; in<br>
the body of a message to <a href="mailto:majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org">majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org</a><br>
More majordomo info at &nbsp;<a href="http://vger.kernel.org/majordomo-info.html" target="_blank">http://vger.kernel.org/majordomo-info.html</a><br>
Please read the FAQ at &nbsp;<a href="http://www.tux.org/lkml/" target="_blank">http://www.tux.org/lkml/</a><br>
</font></blockquote></div><br><br clear="all"><br>-- <br>Regards &amp; Thanks--<br>Subrata

------=_Part_11191_2166332.1215284574037--


--===============2132454340==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Sponsored by: SourceForge.net Community Choice Awards: VOTE NOW!
Studies have shown that voting for your favorite open source project,
along with a healthy diet, reduces your potential for chronic lameness
and boredom. Vote Now at http://www.sourceforge.net/community/cca08
--===============2132454340==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ltp-list mailing list
Ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/ltp-list

--===============2132454340==--
