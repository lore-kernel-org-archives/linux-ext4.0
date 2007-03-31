From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [PATCH] Correction to check_filetype()
Date: Sun, 01 Apr 2007 01:10:10 +0530
Message-ID: <1175370010.3064.15.camel@garfield>
References: <1172049359.4727.15.camel@garfield>
	 <20070331004417.GJ3198@thunk.org>
	 <20070331081624.GF5967@schatzie.adilger.int>
	 <20070331123509.GA25539@thunk.org>  <20070331143926.GG25539@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Lustre-discuss <Lustre-discuss@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46106 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbXCaTiu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 Mar 2007 15:38:50 -0400
In-Reply-To: <20070331143926.GG25539@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2007-03-31 at 10:39 -0400, Theodore Tso wrote:
> On Sat, Mar 31, 2007 at 08:35:09AM -0400, Theodore Tso wrote:
> > And we can't really check the case where a directory gets turned into
> > a regular file without destroying e2fsck's performance, since that
> > would require reading the first block of every single file, and this
> > also significantly increases the chance of false positives.  So it's a
> > lot of complexity for what seems to have always been an artificial
> > test case.

Yes, you can't check whether each regular file is a directory or not.
The only case which is easy to check is whether the mode of a directory
is corrupted since directories will always have a "." and ".." entry. 

Note that we will still lose all data of a regular file if its mode is
changed to lets say, a socket. But there is hardly anything we can do
about this since there is no special check that can be associated with a
regular file.

Since dir_index feature is going to be set by default in ext3/4, maybe
we can check for EXT2_INDEX_FL in check_is_really_dir() and if this flag
is set then check if such a file is a directory or not. So we would not
be reading the first block of each file and yet would be able to correct
most directory mode corruptions.

Thanks,
Kalpak.
