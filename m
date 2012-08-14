From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V5 00/23] ext4: Add inline data support.
Date: Tue, 14 Aug 2012 15:04:47 +0800
Message-ID: <5029F88F.7090106@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma> <20120813150445.GC13072@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:40289 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752218Ab2HNHEv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Aug 2012 03:04:51 -0400
In-Reply-To: <20120813150445.GC13072@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/13/2012 11:04 PM, Theodore Ts'o wrote:
> I had an idea which I think would make inline directories more
> efficient, although it wouldn't be a backwards compatible change with
> the existing patch sets to date.
that should be fine since we don't have much machines deployed by now.
> 
> We don't actually need to store the entry for '.', since we know what
> that should be, and we could just store the parent directory in a
> 4-byte entry.  By not storing the full directory entries for "." and
> "..", we would save 20 bytes, which for a 256 byte inode where only
> 120 bytes or so are available for the inline directory, is pretty
> significant.  (We can just synthesize them for the benefit of readdir
> and lookup --- and I'm pretty sure the VFS is doing its own synthesis
> for "." and possibly ".." already as far as lookup is concerned.)
As andreas said in another e-mail, that would make the codes a little
complex. So in general, in my previous version, I just tried to refactor
most of the codes so that they can work for both inline inode and dir
blocks. But if these changes are merged, we have to re-write all of the
codes that are currently shared, such as ext4_find_entry, empty_dir,
ext4_add_entry etc.

Having said that, maybe it is worth the codes effort if we can see a
great improvement for inline dir. Since Andreas and you are both OK with
this new solution, I can try to re-work the inline data patch to support it.

Thanks
Tao
