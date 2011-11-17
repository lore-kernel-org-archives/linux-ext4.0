From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] debugfs: build read-only variant of debugfs
Date: Thu, 17 Nov 2011 16:11:43 -0500
Message-ID: <20111117211143.GB26341@thunk.org>
References: <1321333509-4607-1-git-send-email-tytso@mit.edu>
 <4EC28845.8000200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33082 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab1KQVLq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Nov 2011 16:11:46 -0500
Content-Disposition: inline
In-Reply-To: <4EC28845.8000200@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 15, 2011 at 09:41:57AM -0600, Eric Sandeen wrote:
> On 11/14/11 11:05 PM, Theodore Ts'o wrote:
> > Create a version of debugfs which only supports read-only examination
> > of the file system metadata (but not the data blocks).  The idea is
> > that this version of debugfs might be suitable to be setuid root, and
> > executable only by members of a particular group, or setgid disk, and
> > globally executable, depending on the security/privacy policies in
> > force at a particular site.
> 
> Just curious - what problem does this solve?
> 
> (Could the same policies simply make direct access to block devices
> read-only for those users, and thus have an fs-independent solution
> to whatever problem is at hand?)

It's not enough to make access to the block devices be read-only;
what's most important in this patch is removing the ability to show
data blocks (i.e., removing the debugfs "cat" and "dump" commands).
After all, a company with very strict user data privacy policies might
require a developer to jump through hoops before getting access which
allowed him or her to bypass file system access controls, whether it
is logging in as root or installing some setuid/setgid binary which
had the effect of bypassing mandatory or discretionary access controls
--- which debugfs's "dump" and "cat" commands effectively do.

There's another reason for removing all of the commands that might be
used to modify file system metadata, as well as forcing the block
device to be opened read-only.  It makes it easier for a
security/privacy committee who might want to audit the code to make
sure no one can use the restricted version of debugfs to flip a setuid
bit, or change a file's permissions, or some other entertaining file
system modification.

I could also imagine this sort of thing could also being useful for
advanced support personnel who need to go on site (say, at a financial
institution in NYC) and who needs to debug a customer's file system or
investigate a performance problem.

						- Ted
