From: Forrest Liu <forrestl@synology.com>
Subject: Re: [PATCH] ext4: fix extent tree corruption that incurred by hole punch
Date: Sun, 9 Dec 2012 03:29:59 +0800
Message-ID: <CAJSVwFM3oAd1B1oauxyDj2QTRXy73X43_6E72209Wy497K8EkA@mail.gmail.com>
References: <1354623069-8124-1-git-send-email-forrestl@synology.com>
	<50C0BDA2.4090203@redhat.com>
	<50C0BE40.5060003@redhat.com>
	<CAOiN93kvSdzsJXqbabuLDcOh2me9wzLUPBsr2UY5BgHFXrhcnA@mail.gmail.com>
	<CAJSVwFOkH3MzdJTVm9M1fFycNqWr4oy+zUNaDUy0LPnXk=YZMg@mail.gmail.com>
	<20121207222922.GI29435@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ashish Sangwan <ashishsangwan2@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64349 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2LHTaA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2012 14:30:00 -0500
Received: by mail-ie0-f172.google.com with SMTP id c13so5205590ieb.31
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2012 11:30:00 -0800 (PST)
In-Reply-To: <20121207222922.GI29435@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
    I have test patch with Ashish's modification, and that have
problem when depth of extent tree is greater than 2.

   I will make a test case with your patch.

Thanks,
Forrest


2012/12/8 Theodore Ts'o <tytso@mit.edu>:
> Hi Forrest,
>
> Can you share an updated version of your patch (with Ashish's
> modification if you've tried testing that)?  And also can you send us
> some automated way to create your test case?  That might make it
> easier for us all to test the same thing and all be on the same page.
>
> I assume you have some C program which which is doing all of the
> punching?
>
> I started trying to create something via a script like this:
>
> touch testfile
> fallocate -l 1G testfile
> for i in $(seq 0 8192 1073741824) ; do fallocate -p -o $i -l 4k testfile ; done
>
> .. where fallocate is from contrib/fallocate.c in the e2fsprogs
> sources (not the fallocate from util-linux) with the attached patch to
> add support for the -p option to do the pnuching.... but then I
> decided it might be better if we all standardized on the same test
> case.  Ideally, if the test case is small enough, we can put it in the
> commit message, or at very least we should look into getting it into
> xfstests, and Eric has suggested.
>
> Cheers,
>
>                                                 - Ted
>
> commit 2658b9616fe63d2fd9e2654676877ab014639a92
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu Dec 6 11:21:44 2012 -0500
>
>     contrib/fallocate: add support for punch functionality
>
>     Also fix the -o option so it works correctly (instead of core
>     dumping).
>
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> diff --git a/contrib/fallocate.c b/contrib/fallocate.c
> index 0e8319f..1436b70 100644
> --- a/contrib/fallocate.c
> +++ b/contrib/fallocate.c
> @@ -35,6 +35,7 @@
>
>  // #include <linux/falloc.h>
>  #define FALLOC_FL_KEEP_SIZE    0x01
> +#define FALLOC_FL_PUNCH_HOLE   0x02 /* de-allocates range */
>
>  void usage(void)
>  {
> @@ -94,12 +95,17 @@ int main(int argc, char **argv)
>         int     error;
>         int     tflag = 0;
>
> -       while ((opt = getopt(argc, argv, "nl:ot")) != -1) {
> +       while ((opt = getopt(argc, argv, "npl:o:t")) != -1) {
>                 switch(opt) {
>                 case 'n':
>                         /* do not change filesize */
>                         falloc_mode = FALLOC_FL_KEEP_SIZE;
>                         break;
> +               case 'p':
> +                       /* punch mode */
> +                       falloc_mode = (FALLOC_FL_PUNCH_HOLE |
> +                                      FALLOC_FL_KEEP_SIZE);
> +                       break;
>                 case 'l':
>                         length = cvtnum(optarg);
>                         break;
