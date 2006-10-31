From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: Shred mount option for ext4?
Date: Tue, 31 Oct 2006 13:32:22 +0100
Message-ID: <20061031123222.GB17972@harddisk-recovery.com>
References: <87hcxkpyas.fsf@willow.rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:10395 "HELO abra2.bitwizard.nl")
	by vger.kernel.org with SMTP id S1161659AbWJaMcY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Oct 2006 07:32:24 -0500
To: Samuel Tardieu <sam@rfc1149.net>
Content-Disposition: inline
In-Reply-To: <87hcxkpyas.fsf@willow.rfc1149.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 31, 2006 at 11:36:11AM +0100, Samuel Tardieu wrote:
> I value my privacy and the privacy of the people I host, and I often
> use shred(1) when erasing files from my server. The goal is to avoid
> that either a hacker or a post-mortem analysis gets ancien data from
> my disk. There are three problems with this approach:
> 
>   - I may forget to use shred sometimes
> 
>   - some files are automatically created and then removed (mails in
>     spool)
> 
>   - data may be replicated in the journal and thus still present on
>     disk
> 
> I could use an encrypted filesystem everywhere, but in many countries,
> one is required to reveal her encryption key to authorities if they
> have a court order (UK for example).

Interesting. I'd say that you don't have to cooperate to get yourself
convicted (i.e.: the right to remain silent). Over here in .nl you do
have to cooperate to decrypt data from a suspect other than yourself,
but you don't have to for your own data.

> I think it would be quite easy to add a mount time option to ext4
> filesystems asking that freed blocks are cleared or erased with random
> data? We could have for example:
> 
>   - free=clear|zero|shred (default "clear", do nothing, "zero" means
>     writing zeroes over the block, useful against attackers trying to
>     recover data from a file system without physical access to it, and
>     "shred" useful against post-mortem analysis of the physical
>     surface)
> 
>   - shred-passes=N (number of passes when using the "free=shred"
>     option, a negative number meaning writing values from 0 to -N onto
>     the block)

FWIW, the idea that you need to rewrite 35 times doesn't longer hold.
Modern drives use PRML encoding techniques, so a few random writes are
enough if you're really paranoid. See the "Epilogue" section in
Gutmann's paper at
http://www.cs.auckland.ac.nz/~pgut001/pubs/secure_del.html .

In practice a single overwrite is enough because of the sheer size of
the task to reproduce the overwritten data. Compare it with a painting
that was "overwritten" with white paint. Sure when you use a microscope
you might be able to figure out some of the original color of the paint
below the white, but it will take years to reproduce it. So far we
haven't found a customer willing to wait a few years for his data...

> Some people (me included) would most likely accept the time penalty of
> using this option on selected filesystems (as well as the reduced
> lifetime of the disks because of the extra writes).

Why don't you just make a libc wrapper for the unlink(2) system call?
(A modified libc.so should do as well). That way it will work for all
of your applications on all filesystems.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
