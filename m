From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: e2image doesn't get backup superblocks?
Date: Mon, 20 Feb 2012 14:22:34 -0500
Message-ID: <4F429D7A.7080202@ubuntu.com>
References: <4F42683F.3070409@ubuntu.com> <20120220190535.GA6541@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:23047 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2BTTWg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2012 14:22:36 -0500
In-Reply-To: <20120220190535.GA6541@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/20/2012 2:05 PM, Ted Ts'o wrote:
> Why do you want to do this?  In general the tools will 
> automatically sync the backups from the master if it is necessary 
> (i.e., in the case of a file system resize, or if there is a
> change in the file system features).  Otherwise, we deliberately
> try to avoid modifying the backups, since any updates to the
> backups is an opportunity to copy corrupted values to the backups,
> or otherwise risk write failures that could smash the backups.

Because I was experimenting with e2fsck -E discard on a raw image and
it was clobbering the superblock, and the backups weren't in the
image.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPQp16AAoJEJrBOlT6nu75YsYH/RfMeeqyq1YzolyRJzeQuQVB
vi1sKkW8LlYutAU3bgJPPxNa3VEUlz5BDqOLzL2DZcsUWUU0t/XkwWGBW8M5UPuy
LQyc/DO2Uz+ho8Jh+WSaOT0FByE5Gp4o5Xu5nhdO27MuTa1q0WiAxGneTnoN+ZNW
G2FkaTAWEGTPhUzV8F32ZnfKNzGJExl5BhiBEm5p5d2jqdzrQS4Uz15ZDbIqSmnL
uJNmtdcBjvq721Rcrf9U15TzZgumxy4VVaNNqR1ZhFG+HnGUVmsqC6HQ1/WaQHWh
WqyXdgX1SlCPP2oAYE8pRvhLQkujg553QBYKkuckQfXD8YnpFWWFQ3fsGLWG5+c=
=cqFo
-----END PGP SIGNATURE-----
