From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 1/5] jbd2: Pass extra bool parameter in journal routines
 to specify if its ok to fail the journal transaction allocation.
Date: Tue, 24 May 2011 17:14:22 -0700
Message-ID: <BANLkTin2=C48nGj0AAf99kiX0aoEBHshtw@mail.gmail.com>
References: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com> <20110524225643.GK26055@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56763 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1EYAOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 May 2011 20:14:43 -0400
Received: by qwk3 with SMTP id 3so3643396qwk.19
        for <linux-ext4@vger.kernel.org>; Tue, 24 May 2011 17:14:42 -0700 (PDT)
In-Reply-To: <20110524225643.GK26055@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 24, 2011 at 3:56 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Apr 24, 2011 at 05:10:41PM -0700, Manish Katiyar wrote:
>> Pass extra bool parameter in journal routines to specify if its ok t=
o
>> fail the journal transaction allocation. If 'true' is passed
>> transaction allocation is done through GFP_KERNEL =A0and ENOMEM is
>> returned else GFP_NOFS is used.
>>
>> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
>
> Hi Manish,
>
> I really apologize for not having time to follow this patch series.
> I've been rather overloaded at the moment.
>
> A couple things. =A0First of all, when you repost a patch which is pa=
rt
> of patch series, I would really appreciated if you did the following:
>
> *) Resend all of the patches in the patch series, each time.
> *) The patches should be in their own mail thread, with either a 0/N
> =A0 =A0 =A0introductory message which describes what the patch series=
 does
> =A0 =A0 =A0at a high level --- this is also a good place to put bench=
mark
> =A0 =A0 =A0numbers or other high level detail that doesn't belong in =
the git
> =A0 =A0 =A0history. =A0If you don't need a introductory message, then=
 make the
> =A0 =A0 =A01/N, 2/N, etc. messages be chained to the first patch in t=
he
> =A0 =A0 =A0patch series. =A0This keeps the patch together and easier =
for
> =A0 =A0 =A0people to find in their inbox. =A0 If you use git, the com=
mands
> =A0 =A0 =A0"git format-patch" and "git send-email" will do this for y=
ou
> =A0 =A0 =A0automatically.
> *) Please put a short summary of the differences between the
> =A0 vN and vN+1 patch after the "---" which separates commit descript=
ion
> =A0 from the rest of the patch. =A0Maintain this as a change log befo=
re the
> =A0 diffstat information:
> =A0 =A0 =A0 v4 -> v5 =A0 Fix up whitespaces and added reviewed-by: XX=
XXX
> =A0 =A0 =A0 v3 -> v4 =A0 Fixed lock ordering issue pointed out by Eri=
c
> =A0 =A0 =A0 v2 -> v3 =A0 Clarified comments in ext4_foobie_bletch()
> =A0 =A0 =A0 v1 -> v2 =A0 Pulled out common code and created a helper =
function,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_foobie_bletch()
> =A0 (If there is no change in a particular patch; you're just reposti=
ng
> =A0 because other patches in the patch series changed, that's fine. =A0=
Just
> =A0 leave the commit log empty for that version, but bump the version
> =A0 number so that all of the patches in a reposting of patch series =
have
> =A0 the same version number.)
>
> For a good example of what this might look like, take a look at Amir'=
s
> snapshot patches, here:
>
> =A0 =A0 =A0 =A0 http://thread.gmane.org/gmane.comp.file-systems.ext4/=
24974
>
> The other thing which I've noticed with these patches is that you mad=
e
> changes to functions in the jbd2 layer, without also immediately
> fixing up all of the callers in the ext4 and ocfs2 file systems. =A0T=
his
> is critically important, because the patches need to be bisectable.
> Note what happened just recently with the punch series; it turns out
> there was a regression that was introduced between patch 2/5 and 3/5
> of that series. =A0Because the tree was fully buildable and would wor=
k
> correctly between each patch, this allowed me to use git bisect to
> find the problem patch. =A0If you add an extra parameter to a functio=
n,
> and then don't fix up the call sites, the kernel won't be buildable
> after the first patch.
>
> Finally, try to keep the short description of the commit to less than
> 72 character. =A0"jbd2: Pass extra bool parameter in journal routines=
 to
> specify if its ok to fail the journal transaction allocation." is jus=
t
> way too long.
>
> Sorry to dump all of these nit picky things on you at all once, but
> because of these issues, it's actually pretty hard to review the rest
> of the patches (since it's hard for me to simply find the latest
> version of the patches in the mail threads), and I'd have to
> completely refactor all of these patches to keep them bisectable, and
> that's more work than I'm prepared to take on at this point in the
> merge window. =A0(And in the future, I'm going to be pushing back on
> this sort of thing more, just so that I scale better.)

Hi Ted,

Thanks for your feedback. I'm still learning how to get my somewhat
useful change into ext4 :-) so will keep these points in mind. Yes,
Jan had also pointed that these patches need to be bisectable, so
actually the last version of the patch in the thread should be
complete in itself. But if you say, I can resend the two patches which
have been reviewed and ack'd by Jan in a new separate mail thread with
appropriate changelog and you can ignore these then. Is that ok ?

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
