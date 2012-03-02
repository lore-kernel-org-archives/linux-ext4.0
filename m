From: Xupeng Yun <xupeng@xupeng.me>
Subject: Re: Bad performance of ext4 with kernel 3.0.17
Date: Fri, 2 Mar 2012 15:06:39 +0800
Message-ID: <CACaf2aawmpX3bBz3r=K0YqUKPR7021kVPjCCi9o=1-FVce_C1Q@mail.gmail.com>
References: <CACaf2aaqxM86DtdZMaaQZfrC+WbLwPjOVd=LmVjk+TvfObYUzQ@mail.gmail.com>
 <20120301194735.GD32588@thunk.org> <CACaf2aacsH-hd9YmXff+DX8qiDjNGeUv6kNe9JamPH6OpaN1Sw@mail.gmail.com>
 <20120302024531.GJ32588@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49460 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2CBHHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2012 02:07:19 -0500
Received: by dajr28 with SMTP id r28so1678072daj.19
        for <linux-ext4@vger.kernel.org>; Thu, 01 Mar 2012 23:07:19 -0800 (PST)
In-Reply-To: <20120302024531.GJ32588@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 2, 2012 at 10:45, Ted Ts'o <tytso@mit.edu> wrote:
> Hmm, it sounds like we're hitting some kind of scaling problem. =C2=A0=
How
> many CPU's/cores do you have on your server? =C2=A0And it would be
> interesting to try varying the --numjobs parameter and see how the
> various file systems behave with 1, 2, 4, 8, and 16 threads.
>

I did various benchmarks with 1, 2, 4, 8, 16 and 32 threads, here are
the results:
http://blog.xupeng.me/misc/4-15krpm-sas-raid10/

> The other thing that's worth checking is to try using filefrag -v on
> the test file after the benchmark has finished, just to make sure the
> file layout is sane. =C2=A0It should be, but I just want to double ch=
eck...

Output of `filefrag -v` after the benchmark has finished:

    # filefrag -v /mnt/ext4/test
    Filesystem type is: ef53
    File size of /mnt/ext4/test is 5368709120 (1310720 blocks, blocksiz=
e 4096)
     ext logical physical expected length flags
       0       0  2424832           32758
       1   32758  2457600  2457590  32758
       2   65516  2490368  2490358  32758
       3   98274  2523136  2523126  32758
       4  131032  2555904  2555894  32758
       5  163790  2588672  2588662  32758
       6  196548  2719744  2621430  32758
       7  229306  2752512  2752502  32758
       8  262064  2785280  2785270  32758
       9  294822  2818048  2818038  32758
      10  327580  2850816  2850806  32758
      11  360338  2883584  2883574  32758
      12  393096  2916352  2916342  32758
      13  425854  2949120  2949110  32758
      14  458612  2981888  2981878  32758
      15  491370  3014656  3014646  32758
      16  524128  3047424  3047414  32758
      17  556886  3080192  3080182  32758
      18  589644  3112960  3112950  32758
      19  622402  3178496  3145718  32758
      20  655160  3211264  3211254  32758
      21  687918  3244032  3244022  32758
      22  720676  3276800  3276790  32758
      23  753434  3309568  3309558  32758
      24  786192  3342336  3342326  32758
      25  818950  3375104  3375094  32758
      26  851708  3407872  3407862  32758
      27  884466  3440640  3440630  32758
      28  917224  3473408  3473398  32758
      29  949982  3506176  3506166  32758
      30  982740  3538944  3538934  32758
      31 1015498  3571712  3571702  32758
      32 1048256  3604480  3604470  32758
      33 1081014  3637248  3637238  32758
      34 1113772  3702784  3670006  32758
      35 1146530  3735552  3735542  32758
      36 1179288  3768320  3768310  32758
      37 1212046  3801088  3801078  32758
      38 1244804  3833856  3833846  32758
      39 1277562  3866624  3866614  32758
      40 1310320  3899392  3899382    400 eof
    /mnt/ext4/test: 41 extents found

--=20
Xupeng Yun
http://about.me/xupeng
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
