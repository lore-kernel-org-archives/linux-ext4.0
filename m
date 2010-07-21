From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/2] mbcache: Remove unused features
Date: Wed, 21 Jul 2010 17:18:39 -0600
Message-ID: <4F3D0C4D-BA6B-490E-B656-774578B3F67B@dilger.ca>
References: <4C46FD67.8070808@redhat.com> <20100721202636.B94F83C539AA@imap.suse.de>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Andreas Gruenbacher <agruen@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:48421 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0GUXSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jul 2010 19:18:40 -0400
In-Reply-To: <20100721202636.B94F83C539AA@imap.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-07-19, at 10:19, Andreas Gruenbacher wrote:
> The mbcache code was written to support a variable number of indexes,
> but all the existing users use exactly one index.  Simplify to code to
> support only that case.
> 
> There are also no users of the cache entry free operation, and none of
> the users keep extra data in cache entries.  Remove those features as
> well.

Is it possible to allow mbcache to be disabled, either for the whole kernel, on a per-filesystem basis, or adaptively if the cache hit rate is very low (any of these is fine, not all of them).

The reason I ask is because under some uses mbcache is adding significant overhead for very little/no benefit.  If the xattr blocks are not shared, then every xattr is stored in a separate entry, and there is a single spinlock protecting the whole mbcache for all filesystems.

On systems with large memory for the buffer cache (6M+ buffer heads, 5M inodes in memory) there are very long hash chains to be searched, and this slows down filesystem performance dramatically.  We became aware of this problem because of NMIs triggering due to long spinlock hold times in mb_cache_entry_insert() on a server with 32GB of RAM.

To reproduce the problem, a simple test can be done with a bunch of kernel source trees (not hard-linked trees though, must be unpacked separately):

$ for i in linux-* ; do
    time du ${i}
  done

gives :
 8s for the first one
12s for the 10th
27s for the 25th
48s for the 50th
95s for the 100th
=> this is strictly linear

opreport -l vmlinux show :
 68.12% in mb_cache_entry_insert
 21.71% in mb_cache_entry_release
  4.27% in mb_cache_entry_free
  1.49% in mb_cache_entry_find_first
  0.82% in __mb_cache_entry_find

(see https://bugzilla.lustre.org/show_bug.cgi?id=22771 for full details)

I don't think fixing the mbcache to be more efficient (more buckets, more locks, etc) is really solving the problem which is that mbcache is adding overhead without value in these situations.

Attached is a patch that allows manually disabling mbcache on a per-filesystem basis with a mount option.  Better would be to automatically disable it if e.g. some hundreds or thousands of objects were inserted into the cache and there was < 1% cache hit rate.  That would help everyone, even those people who don't know they have a problem.

Cheers, Andreas





