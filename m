From: kevin granade <kevin.granade@gmail.com>
Subject: Re: ext4_lazyinit_thread: 'ret' may be used uninitialized in this function
Date: Tue, 2 Nov 2010 13:46:23 -0500
Message-ID: <AANLkTim9JbCk29oPjrYMSfhtHL4tL4uHtDq_xZoe7tzg@mail.gmail.com>
References: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de> <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
 <20101102182911.GE25614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59760 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0KBSqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Nov 2010 14:46:46 -0400
In-Reply-To: <20101102182911.GE25614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 2, 2010 at 1:29 PM, Ted Ts'o <tytso@mit.edu> wrote:
>
> On Mon, Nov 01, 2010 at 04:27:26PM +0100, Lukas Czerner wrote:
> >
> > thank you for noticing this, because I actually do not see the warn=
ing
> > (I wonder why...), but it is definitely a bug, so the trivial patch=
 below
> > should fix that.
>
> This is a slightly less trivial fix that eliminates the need for the
> "ret" variable entirely.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
> commit e048924538f0c62d18306e2fea0e22dac0140f6e
> Author: Theodore Ts'o <tytso@mit.edu>
> Date: =A0 Tue Nov 2 14:19:30 2010 -0400
>
> =A0 =A0ext4: "ret" may be used uninitialized in ext4_lazyinit_thread(=
)
>
> =A0 =A0Newer GCC's reported the following build warning:
>
> =A0 =A0 =A0 fs/ext4/super.c: In function 'ext4_lazyinit_thread':
> =A0 =A0 =A0 fs/ext4/super.c:2702: warning: 'ret' may be used uninitia=
lized in this function
>
> =A0 =A0Fix it by removing the need for the ret variable in the first =
place.
>
> =A0 =A0Signed-off-by: "Lukas Czerner" <lczerner@redhat.com>
> =A0 =A0Reported-by: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
> =A0 =A0Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8d1d942..4d7ef31 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2699,7 +2699,6 @@ static int ext4_lazyinit_thread(void *arg)
> =A0 =A0 =A0 =A0struct ext4_li_request *elr;
> =A0 =A0 =A0 =A0unsigned long next_wakeup;
> =A0 =A0 =A0 =A0DEFINE_WAIT(wait);
> - =A0 =A0 =A0 int ret;
>
> =A0 =A0 =A0 =A0BUG_ON(NULL =3D=3D eli);
>
> @@ -2723,13 +2722,12 @@ cont_thread:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0elr =3D list_entry(pos=
, struct ext4_li_request,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 lr_request);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_after_eq(jiffi=
es, elr->lr_next_sched))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 ext4_run_li_request(elr);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_re=
move_li_request(elr);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continu=
e;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_after_eq(jiffi=
es, elr->lr_next_sched)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ext=
4_run_li_request(elr) !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 /* error, remove the lazy_init job */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ext4_remove_li_request(elr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (time_before(elr->l=
r_next_sched, next_wakeup))

What do you think about this option for the second hunk? (not anything-=
tested)

@@ -2723,13 +2722,11 @@ cont_thread:
                       elr =3D list_entry(pos, struct ext4_li_request,
                                        lr_request);
-                       if (time_after_eq(jiffies, elr->lr_next_sched))
-                               ret =3D ext4_run_li_request(elr);
-
-                       if (ret) {
-                               ret =3D 0;
-                               ext4_remove_li_request(elr);
-                               continue;
+                       if (time_after_eq(jiffies, elr->lr_next_sched) =
&&
+                           ext4_run_li_request(elr) !=3D 0) {
+                               /* error, remove the lazy_init job */
+                               ext4_remove_li_request(elr);
+                               continue;
                       }

                       if (time_before(elr->lr_next_sched, next_wakeup)=
)
--

Though obviously it's a pretty subjective style issue.
Kevin Granade

> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
