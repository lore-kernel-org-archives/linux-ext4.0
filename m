From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: debugfs: ls -p can print invalid characters
Date: Mon, 30 Jan 2017 22:34:22 -0500
Message-ID: <20170131033422.nvrye3qnmqrc7kpj@thunk.org>
References: <1482347505-11200-1-git-send-email-samuel.voss@rockwellcollins.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
        Clayton Shotwell <clayton.shotwell@rockwellcollins.com>
To: Samuel Voss <samuel.voss@rockwellcollins.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47240 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750819AbdAaDeY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 30 Jan 2017 22:34:24 -0500
Content-Disposition: inline
In-Reply-To: <1482347505-11200-1-git-send-email-samuel.voss@rockwellcollins.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 21, 2016 at 01:11:45PM -0600, Samuel Voss wrote:
> From: Clayton Shotwell <clayton.shotwell@rockwellcollins.com>
> 
> The recent modification to the "ls -p" function can print out characters
> that the other ls functions do not print out. Adding a slight change to
> use the same print function for all of the ls options.
> 
> Signed-off-by: Clayton Shotwell <clayton.shotwell@rockwellcollins.com>
> Signed-off-by: Samuel Voss <samuel.voss@rockwellcollins.com>

This was deliberate.  The "-p" option for debugfs's ls command is
intended for used when piping to a shell script, and the use of '/' is
because it is _rare_ for that character to show up file names.

If I were doing it all over again (ls -p has been around for a very
long time), I'd use the just-added print_c_string() function in which
encodes special characters using C strings (e.g., \001\000\n\t, etc.)
and then use an unencoded "RS" ASCII character (\036) as the record
separator between each field.  But since there are existing
shell/perl/python scripts and other programs out there depending on
the output of debugfs's ls -p, I don't want to change the output at
this point.

Cheers,

       	   				- Ted
