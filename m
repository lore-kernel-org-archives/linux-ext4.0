From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: question about fsync
Date: Mon, 25 Oct 2010 08:54:14 -0400
Message-ID: <5CFF01DA-8C9E-496D-A2F1-D968CFB842EF@mit.edu>
References: <AANLkTinFkS1Uf+GJT+SE43KpqoUWyJERBFTzxKyLgX+u@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Filipe David Manana <fdmanana@apache.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:56507 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469Ab0JYM7R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Oct 2010 08:59:17 -0400
In-Reply-To: <AANLkTinFkS1Uf+GJT+SE43KpqoUWyJERBFTzxKyLgX+u@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Oct 25, 2010, at 7:49 AM, Filipe David Manana wrote:

> - opens a file (write append mode) and writes data to it
> - opens a 2nd file descriptor for that same file (write append mode as
> well) and does an fsync call on this 2nd file descriptor
> - closes the 2nd file descriptor
> - continues writing to the 1st file descriptor
> - etc
> 
> Is there a risk that some of the data might not get fsynced to disk? I
> mean, is it possible that the 2nd file descriptor doesn't have all the
> same metadata as the first one?

What do you mean by "risk?"  For most Linux file systems, including ext2, ext3, and ext4, all of the data will be sync'ed out to disk.   However, this is not guaranteed by POSIX or the Single Unix Specification.   So in theory, there might exist some POSIX/SUS compliant implementation that would not sync out the data.  I think most Unix or Linux-compatible systems are such that you could count on this, but it's not a portable thing that you can count upon.   I have no idea what the Windows POSIX layer would do in this situation, for example, or the Eunice Emulation layer for VMS.  (Back in the Perl 3 days, Larry Wall's configure script would test for Eunice, and if not found, print the message, "Congratulations.  You're not running Eunice."  :-)

-- Ted

