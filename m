From: Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 8/9] tests: add basic e2fsck regression test for fixing
 the quota inode
Date: Tue, 13 May 2014 00:29:54 -0700
Message-ID: <CAGr1F2EwOD9xRY07_Jpj1z4i37nQaEExkvF+SCkO3TECSX4W=A@mail.gmail.com>
References: <1399782773-20029-1-git-send-email-tytso@mit.edu> <1399782773-20029-9-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:38779 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaEMHaO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 May 2014 03:30:14 -0400
Received: by mail-oa0-f42.google.com with SMTP id j17so9650917oag.29
        for <linux-ext4@vger.kernel.org>; Tue, 13 May 2014 00:30:14 -0700 (PDT)
In-Reply-To: <1399782773-20029-9-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 10, 2014 at 9:32 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: adityakali@google.com

Reviewed-by: Aditya Kali <adityakali@google.com>

Thanks!

> ---
>  tests/f_quota/debugfs-cmds |   7 +++++++
>  tests/f_quota/expect.0     |  21 +++++++++++++++++++++
>  tests/f_quota/expect.1     |  13 +++++++++++++
>  tests/f_quota/expect.2     |   7 +++++++
>  tests/f_quota/image.gz     | Bin 0 -> 1046 bytes
>  tests/f_quota/name         |   1 +
>  tests/f_quota/script       |   4 ++++
>  7 files changed, 53 insertions(+)
>  create mode 100644 tests/f_quota/debugfs-cmds
>  create mode 100644 tests/f_quota/expect.0
>  create mode 100644 tests/f_quota/expect.1
>  create mode 100644 tests/f_quota/expect.2
>  create mode 100644 tests/f_quota/image.gz
>  create mode 100644 tests/f_quota/name
>  create mode 100644 tests/f_quota/script
>
> diff --git a/tests/f_quota/debugfs-cmds b/tests/f_quota/debugfs-cmds
> new file mode 100644
> index 0000000..112a3ff
> --- /dev/null
> +++ b/tests/f_quota/debugfs-cmds
> @@ -0,0 +1,7 @@
> +list_quota user
> +list_quota group
> +get_quota user 0
> +get_quota user 100
> +get_quota user 34
> +get_quota group 0
> +
> diff --git a/tests/f_quota/expect.0 b/tests/f_quota/expect.0
> new file mode 100644
> index 0000000..c0ad63d
> --- /dev/null
> +++ b/tests/f_quota/expect.0
> @@ -0,0 +1,21 @@
> +debugfs: list_quota user
> + user id     blocks    quota    limit      inodes    quota    limit
> +       0      13312        0        0           2        0        0
> +      34       1024        0        0           1        0        0
> +     100       2048       32       50           2       20       30
> +debugfs: list_quota group
> +group id     blocks    quota    limit      inodes    quota    limit
> +       0      16384        0        0           5        0        0
> +debugfs: get_quota user 0
> + user id     blocks    quota    limit      inodes    quota    limit
> +       0      13312        0        0           2        0        0
> +debugfs: get_quota user 100
> + user id     blocks    quota    limit      inodes    quota    limit
> +     100       2048       32       50           2       20       30
> +debugfs: get_quota user 34
> + user id     blocks    quota    limit      inodes    quota    limit
> +      34       1024        0        0           1        0        0
> +debugfs: get_quota group 0
> +group id     blocks    quota    limit      inodes    quota    limit
> +       0      16384        0        0           5        0        0
> +debugfs:
> diff --git a/tests/f_quota/expect.1 b/tests/f_quota/expect.1
> new file mode 100644
> index 0000000..0b3b4cf
> --- /dev/null
> +++ b/tests/f_quota/expect.1
> @@ -0,0 +1,13 @@
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +[QUOTA WARNING] Usage inconsistent for ID 0:actual (13312, 2) != expected (14336, 3)
> +[QUOTA WARNING] Usage inconsistent for ID 100:actual (2048, 2) != expected (1024, 1)
> +Update quota info for quota type 0? yes
> +
> +
> +test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
> +test_filesys: 14/16 files (14.3% non-contiguous), 36/100 blocks
> +Exit status is 1
> diff --git a/tests/f_quota/expect.2 b/tests/f_quota/expect.2
> new file mode 100644
> index 0000000..bfc558d
> --- /dev/null
> +++ b/tests/f_quota/expect.2
> @@ -0,0 +1,7 @@
> +Pass 1: Checking inodes, blocks, and sizes
> +Pass 2: Checking directory structure
> +Pass 3: Checking directory connectivity
> +Pass 4: Checking reference counts
> +Pass 5: Checking group summary information
> +test_filesys: 14/16 files (14.3% non-contiguous), 36/100 blocks
> +Exit status is 0
> diff --git a/tests/f_quota/image.gz b/tests/f_quota/image.gz
> new file mode 100644
> index 0000000000000000000000000000000000000000..9cea6556e941fb0e3fb2bf09a29895ca246cad50
> GIT binary patch
> literal 1046
> zc-o!F{WF^f0KoBdZspF1-D*lrSk+5+=nz^>MD?0oJL0vO3C%`l6v@;wr3l-3tD%~?
> zzGRWMMx?1^&PXhr%sb7Cmj-$B49Sp)h}T6l&vyG0_PzW3@`csfKw9?*32#~HRWX@3
> zk}G7(Gj~kbmczDY#KKO6Eue#tb%hIIj*ow|o40q~c;Lm+%?A5U)Z)IZ(z}mu`9vY_
> z%(UEzKYq`?uX<Tj`=`q8T`0!k(sBS<D~Bu2Qq!};>D&73?b1R3|1Veohm+-H_0EfE
> zk4X=7q^nJ%ZDXq3U5n<c)?m_!hDdc_$DEod!|)5(SZ^n)e>mZCb-u@b<@u8#JO^xX
> zaTWlG==RYiCMkYIf+uTgPMPB#vD(0c{1WpN)zA;BhBeR`nlTiAv!UC}@8l8=nskyC
> z!sLE0k%#opz6m;OkuW#qJn_?NJ?&6Z!O?Lt{CAG#(Kd5zEUO#LF|49+0{010eR)@}
> zaj_E|jq(o-Uqn{IMC$ye<kKp6LN@l5DqU0ecxfZW&kv<6G@N@7?NXQFT3YHk-1>~9
> zQb-<swsh&&rOLyBkk=jLFCxyDTWMjjVA-MdYt&QAu{~%zIpWQK3nD1V-Jv`r=aA7O
> zy(Li6^W0RTs(Ps$-q8&J5kpU10^j~Vfh-U>PeVD@Rz#V(jGNqnW8-fTLB4|S`?IaW
> zS*LQ-`#GVY2eQS$-$mu)J=9%qUD@%?B(Z})An%kKKtUerTxMTt<sX`pu%x1Jq++$$
> z9KBj&HEQpcC<d({5Qsp|HD4p${&@4NMZ9+)t=3_*l!+m%Unvm98kFioG5ned=z7Jz
> zKAy2D?zUYOR}mZb?pkDG@FH+x`|B`M6;@6DjVt^vbb6i07p);D2S`^foo7ri?nRJm
> z1cDGs;*nuj`FF<9U4XA_ChzaE22vPpLEs#)ZDOQS3s&ScP|3rf^k-!Om3=@JkCz7G
> z0H&dI2S{KEjT2mh<r~(KVrY9%s#T}G3;}0Z!U5feBmh8wJs8V=AIy&m66xfzvpa^P
> zjX}o#u4Ox+D=!$&p}lZgb%~4jyZ%JObERQsWIlGR8`TU-8oX$I+&H-OiyZMD{C$@!
> zgp;E#FF2uLr9F;%HKqzD(I`YKK_l@lO%!x;OdB;To`udzf#RB((iUFQlT@Kp7IA^_
> zQzZX>0JEn{L%DUK@U(AeZBwQfb69VGr6Qx{My9ZGzv6aB;=<=X(!ZRv6HM8+2s(bc
> zKR(wV@pAS}%@34MpfGxoajRx+e0oh<lRoBEA4OaEptZYQAq{4?nM_mtp3#?KZBEaZ
> zkBZOuIx;@WOZ07alPFM03harg?7Wu7;R<woJqFuCY3lnBvIm9y{{-%b)+I!f5pw?+
> F<R3nT9HRgL
>
> literal 0
> Hc-jL100001
>
> diff --git a/tests/f_quota/name b/tests/f_quota/name
> new file mode 100644
> index 0000000..27ea8ba
> --- /dev/null
> +++ b/tests/f_quota/name
> @@ -0,0 +1 @@
> +fix incorrect usage stats in quota
> diff --git a/tests/f_quota/script b/tests/f_quota/script
> new file mode 100644
> index 0000000..bf25e07
> --- /dev/null
> +++ b/tests/f_quota/script
> @@ -0,0 +1,4 @@
> +AFTER_CMD='$DEBUGFS -f $test_dir/debugfs-cmds $TMPFILE 2>&1 | sed -f $cmd_dir/filter.sed > $test_name.0.log'
> +PASS_ZERO=true
> +
> +. $cmd_dir/run_e2fsck
> --
> 1.9.0
>



-- 
Aditya
