Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47DE31353B
	for <linux-ext4@vger.kernel.org>; Sat, 18 Apr 2026 21:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776548712; cv=none; b=pgguoZ1NNzavklxLv5e90wGZDbyc+/Hv5bi+LqB8QvUmULAPHzJv0hiJGvaHlKQut5DITE5TSY6jaP4cniDmADlVQj5O2LVyMXBpXsrem0fqVXVYYkK1Co7e+Uj0di4oeM0W6J+y68zR36kO3QlAKi0pQY8I4qmIXo+Ie5JKNWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776548712; c=relaxed/simple;
	bh=tdK5GL6eKr6AT22Whmlvx3PrWLr+Xh1x+YYs7r5P0zA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMpaftNTEe7tE4y4xOj76I3ke2siF+c1W4vv0wsCb/IMOS5hTMB8p/thChWv5K83HmJNLs9HbCEr8143vo40MX3KKSi6u01xnU9JnL1A/oOHfzdVcnKTlXK64JhjwuZAYt1M7f0wHa85k9HUHPiN775OEP3NyuOqxSgD151PAEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=cqKR8e8z; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="cqKR8e8z"
Received: from macsyma.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63ILixXq009919
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Apr 2026 17:45:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1776548701; bh=JCFtJ4DHklbw4SMxTXrtpxhA3ardLKsNq4E3DWSfuGM=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=cqKR8e8zbPrGCMn1E1BdyAH8HEjOoHjS0qETFap0XupvChBjYpUujRObQmTbL73Np
	 MhaZnDfvP2WvElf7w0/bAWWCot+KwBoaTyUKjaf1Pu6JGWfU4ezhH/Jj2JRJv53sjO
	 7cVDQ4HXI16M5VL3ReJsVBCQTvHFDRLUCMru6+KAOToTJFJjJpOPliq1iJIzValNKl
	 svUxEuv9RGEMG448vm/zcBUDsiWRn9485Lc1/svU9atFUzP1svP9+1TMBYk2Tkorpq
	 qrTYecYJEPaSKW47PmyIKa4W7SU6gGb7YjOVOTTrLQGODBze/nhtfa7FxMI00TBFK6
	 LfJNCIjkhMoWg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 642A363B9B44; Sat, 18 Apr 2026 17:43:59 -0400 (EDT)
Date: Sat, 18 Apr 2026 17:43:59 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH 0/3] Data in direntry (dirdata) feature
Message-ID: <20260418214359.GA58909@macsyma-wired.lan>
References: <20260417213723.74204-1-artem.blagodarenko@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417213723.74204-1-artem.blagodarenko@gmail.com>

Hi Artem,

Thank you for sending this patch.  My primary concern with it is that
it seems to be optimized for minimizing the changes for the
out-of-tree Lustre Server patches, but not for necessasrily from the
upstream perspective.

First, there is no way to actually set any dirdata feature using just
the upstream patch.  Presumably, the out-of-tree Lustre patches call
ext4_insert_dentry_data() with a non-NULL data, or add_dirent_to_buf()
in fs/ext4/namei.c was further patched so that the data variable on
the stack gets set to a non-NULL --- but in your patches, data is
always NULL, which manes the data passed into
ext4_insert_dentry_data() is always NULL.

Since there is no way to actually set dirdata after the upstream
kernel, nor is there any way to set the dirdata using debugfs (the
patches to e2fsprogs only affect e2fsck, and there is no way to
examine the dirdata or set dirdata via debugfs), it's going to make it
very hard to test the kernel patches without using pre-existing file
system images.  I haven't seen the xfstests patches from you yet, but
this is the only way you could test the code paths as far as I can
tell.

Secondly, there are a lot of changes because you rename functions like
ext4_dir_rec_len() to ext4_dirent_rec_len() and ext4_insert_dirent()
to ext4_insert_dentry_data().  Especially for the ext4_dir_rec_len()
change, it's not strictly speaking necessary, and while I can see the
argument that it might make it more readable / understandable, if you
*really* want to do the rename, it's better to break that out into a
separate patch which *just* renames the function, and then change the
function prototype in a subsequent patch.


As far as how get this patch upstream, the challenge with LUFID (and
dirdata in general), is that the dirdata has to set when the directory
entry is created, and is immutable afterwards.  And so if we want to
have a way to create directory entries with an LUFID, we either need
to (a) use the out-of-tree Lustre patches, (b) plumb through some new
interface through the VFS and potentially some new openat3() system
call, or (c) add some new ext4 ioctl EXT4_IOC_SET_LUFID which sets the
LUFID on an already existing pathname.

(c) is problematic since it's a different code path than what the
Lustre server would use, and it would require using the dentry used to
opened the file to decide which directory entry to mutate, and it also
violates the presumption that the directory entry's dirdata is
immutable after the directory entry is created.

Speaking of which, I'm really confused with *why* the LUFID is being
stored in the diretory entry.  From what I can tell, from [1], the FID
is essentially a distributed inode number.  Given that, why isn't the
LUFID stored in an xattr?  What am I missing?

[1] https://wiki.lustre.org/Understanding_Lustre_Internals

						- Ted
