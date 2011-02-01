From: Stuart Pook <stuart8761@pook.it>
Subject: Re: error ext4_mb_generate_buddy:726 & add_dirent_to_buf:1272 after
 online resize
Date: Tue, 01 Feb 2011 12:45:32 +0100
Message-ID: <4D47F25C.9060608@pook.it>
References: <S1752440Ab1APNtL/20110116134911Z+826@vger.kernel.org> <4D32FACD.7020907@pook.it> <4D3300A5.1090300@pook.it> <4D44919C.6010404@pook.it> <20110129223310.GD19287@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:54454 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab1BALpr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Feb 2011 06:45:47 -0500
Received: from shiva (unknown [88.171.134.228])
	by smtp6-g21.free.fr (Postfix) with ESMTP id A6AE78227E
	for <linux-ext4@vger.kernel.org>; Tue,  1 Feb 2011 12:45:40 +0100 (CET)
In-Reply-To: <20110129223310.GD19287@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 29/01/11 23:33, Ted Ts'o wrote:
> ... is strictly speaking not an error.  It is a status report
> indicating that in the past your file system had suffered an error.
> The first error was at 1295177566 seconds past the epoch, or at:
>
> % date -d @1295177566
> Sun Jan 16 06:32:46 EST 2011

:; date -d @1295177566
Sun Jan 16 12:32:46 CET 2011

It's little later in my timezone and that was just after I resized my file system.

> If you upgrade to e2fsck 1.41.14, it will reset the error counter and
> the first/last most recent errors.

I upgraded to 1.41.14, ran e2fsck and the messages have stopped.

We still don't know what caused the initial errors (which have now vanished). As they started just after an online resize I'd guess that there were (are?) some bugs in that code. I'll avoid doing online resizes of my ext4 file systems for the moment.

> The idea behind this is that
> sometimes people aren't paying close attention to their
> /var/log/messages file, so this is a periodic informational reminder,
> printed once a day.

That's a good idea. Once you know how to translate 1295177566 into a real time, you can go and look in the logs for the correct day.

>  If you are creating shell scripts to find errors,
> match on "EXT4-fs Error", for example "EXT4-fs error (dm-28): disk on
> fire".  Warnings will be denoted with "EXT4-fs warning", and and
> information messages, such as this one just start with "EXT4-fs", as
> in "EXT4-fs (dm-28): ..."

perhaps it would be better if they started with "EXT4-fs repeat message" (or something that you might be able to find with google)

> Hope this helps,

It sure does, thanks
Stuart
