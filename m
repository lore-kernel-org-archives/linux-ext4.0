From: Jonathan Bastien-Filiatrault <joe@x2a.org>
Subject: Re: EXT4 ENOSPC Bug
Date: Sat, 29 Nov 2008 15:32:26 -0500
Message-ID: <4931A6DA.2070007@x2a.org>
References: <200811291418.24672.andres@anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, adilger@sun.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Andres Freund <andres@anarazel.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754683AbYK2Ukq@vger.kernel.org>
In-Reply-To: <200811291418.24672.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andres Freund wrote:
> Hi Ted, Hi Andreas, hi all,
>
> On a testsystem (spare laptop) with ext4 as root filesystem sometimes the
> system starts to return ENOSPC to all write/create syscalls.
> Sometimes the system runs without problems, at other times it starts
having
> problems soon after boot.
> A reboot resolves the problem temporarily.
I have had the same problem.
>
> I don't see  a specific usage triggering the problem.
Using Vuze(formerly azureus) seemed to trigger the problem. My system
can run fine for days before it happens.
>
> Deleting some files sometimes allows the creation (just touch
$unused_filename)
> of some files, but not many.
>
> Anything I can do to help you to debug the problem?
>
> Andres
I do not have much more info to give you, this is mostly a "me too".

Thanks,
Jonathan
