Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CBF28C2BF
	for <linux-ext4@vger.kernel.org>; Thu, 23 Apr 2026 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776961292; cv=none; b=gqGBqtBcSj2Y8hMgYHl8L26cTvzg0hYAY5T1lxIm/R+r/A4GP/wUkWVd1gNeLUFqt69CVpeMYJaOAfgsolOodOfTE/qY/PrNd9XB27XrfJlPBdKGaFThBLZV9ew1KGy1U1vY84hIqSDDtv9oza2/tLSp3aTTKz825qeFYxZ0t7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776961292; c=relaxed/simple;
	bh=xp2pMTo3aw7cLhP5uDme1JVwUIzmEWSjps8fmMShWkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8MQjjfCS0T68vvcIireZlHiqUm/oEpvz1MktkEq1A4qLA0D1gNouynoHBYtl1UhAksjv1zrW/SKT+p6LGvIT2s5QSuixcEBYhOeS6dRmN6GIk04oQfR2yRBLVUfw4ZY0jTcbLc5jsZyeeYEd7Q05UtdAnTb324gaBRKFP3jwrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=e0J5JW3u; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="e0J5JW3u"
Received: from macsyma.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63NGKmT9022089
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 12:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1776961251; bh=xrabulbNwCoYtGMFi0J6CHNFR1BHJnva+CZE5x1zRII=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=e0J5JW3uJvECgwxY803wsj1yO8F15mowTRD1H+XDZCfFZeZmnPoHHkYBvMK9kibJt
	 bzKKJ0EVLimGcKe8Sn3lC3vRq93qD/egK2dYQM0K/kCUj/ZQ7VRQ9E/Ynm2C3qOR0K
	 OOGfSxQTwdLsGaYP9PlEgfDKhxXsvrqHkPCd/DlfHt+yvyIMzq6GvIJR6dxUu+ljc3
	 aHbFyHP805/vCItxQxWIFFJgEW0llNQ71pKZwOePYXJ7UXPC9Cm2lEJvin6nMUS4QQ
	 +qMNsCOPxMk5xrJDbdQrIU4lLwRFXQDfHLm0WWIMyQBfGFsGGvHuBNlw7nehobqfm0
	 02VY8uCi4qXgQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id C584C64BE250; Thu, 23 Apr 2026 12:19:47 -0400 (EDT)
Date: Thu, 23 Apr 2026 12:19:47 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Baolin Liu <liubaolin12138@163.com>
Cc: adilger.kernel@dilger.ca, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
        yi.zhang@huawei.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangguanyu@vivo.com,
        Baolin Liu <liubaolin@kylinos.cn>, Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3 v3 2/2] ext4: allow clearing mballoc stats through
 mb_stats
Message-ID: <20260423161947.GB68318@macsyma-wired.lan>
References: <20260422015026.7170-1-liubaolin12138@163.com>
 <20260422015026.7170-3-liubaolin12138@163.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422015026.7170-3-liubaolin12138@163.com>

On Wed, Apr 22, 2026 at 09:50:25AM +0800, Baolin Liu wrote:
> From: Baolin Liu <liubaolin@kylinos.cn>
> 
> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
> mballoc statistics when 0 is written.

At the moment to enable mb_stats the system administrator needs to
write "1" to /sys/fs/ext4/<dev>/mb_stats, and writing "0" to the sysfs
file will pauce the statistics colleciton (but not clear the
statistics).  Adding a way to clear the statistics by writing to the
procfs file might be confusing to users.

So.... as a suggestion, if you're adding to the ability to write to
/proc/fs/.../mb_stats, what if we make things work by

   * Write 1 to /proc/fs/.../mb_stats to  enable statistics collection
   * Write 0 to /proc/fs/.../mb_stats to  disable statistics collection
   * Write -1 to /proc/fs/.../mb_stats to clear statistics counters

And then deprecate the /sys/fs/.../mb_stats variable (but we probably
won't be able to remove it for at least a year or two).

	       	       	  	    	- Ted
