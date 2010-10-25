From: Filipe David Manana <fdmanana@apache.org>
Subject: Re: question about fsync
Date: Mon, 25 Oct 2010 23:10:15 +0100
Message-ID: <AANLkTinTBz6ne37Y=xDeXnQQM39Mk5NYHHfEkHBd-_wP@mail.gmail.com>
References: <AANLkTinFkS1Uf+GJT+SE43KpqoUWyJERBFTzxKyLgX+u@mail.gmail.com>
	<5CFF01DA-8C9E-496D-A2F1-D968CFB842EF@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44803 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0JYWKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Oct 2010 18:10:18 -0400
Received: by fxm16 with SMTP id 16so3424855fxm.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Oct 2010 15:10:17 -0700 (PDT)
In-Reply-To: <5CFF01DA-8C9E-496D-A2F1-D968CFB842EF@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore, thanks for your answer.

A similar question:

I have 2 threads. Both open the same file, but each using its own
(different) file descriptor.

If one thread writes data past the eof (appends data), will the other
one be able to read it with pread call (an offset past the eof it
found when it opened the file)?

I  would just like to know if it's something safe to do on Linux and
all Posix compliant platforms (and eventually Windows). (I tested this
with non C code and it worked)

best regards,


On Mon, Oct 25, 2010 at 1:54 PM, Theodore Tso <tytso@mit.edu> wrote:
>
> On Oct 25, 2010, at 7:49 AM, Filipe David Manana wrote:
>
>> - opens a file (write append mode) and writes data to it
>> - opens a 2nd file descriptor for that same file (write append mode =
as
>> well) and does an fsync call on this 2nd file descriptor
>> - closes the 2nd file descriptor
>> - continues writing to the 1st file descriptor
>> - etc
>>
>> Is there a risk that some of the data might not get fsynced to disk?=
 I
>> mean, is it possible that the 2nd file descriptor doesn't have all t=
he
>> same metadata as the first one?
>
> What do you mean by "risk?" =C2=A0For most Linux file systems, includ=
ing ext2, ext3, and ext4, all of the data will be sync'ed out to disk. =
=C2=A0 However, this is not guaranteed by POSIX or the Single Unix Spec=
ification. =C2=A0 So in theory, there might exist some POSIX/SUS compli=
ant implementation that would not sync out the data. =C2=A0I think most=
 Unix or Linux-compatible systems are such that you could count on this=
, but it's not a portable thing that you can count upon. =C2=A0 I have =
no idea what the Windows POSIX layer would do in this situation, for ex=
ample, or the Eunice Emulation layer for VMS. =C2=A0(Back in the Perl 3=
 days, Larry Wall's configure script would test for Eunice, and if not =
found, print the message, "Congratulations. =C2=A0You're not running Eu=
nice." =C2=A0:-)
>
> -- Ted
>
>



--=20
=46ilipe David Manana,
fdmanana@gmail.com, fdmanana@apache.org

"Reasonable men adapt themselves to the world.
=C2=A0Unreasonable men adapt the world to themselves.
=C2=A0That's why all progress depends on unreasonable men."
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
