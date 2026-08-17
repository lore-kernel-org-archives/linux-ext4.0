Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4530E3B8BB6
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 08:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786955058; cv=none; b=P//AaaRQbK/6Un1EqdGMAiKFcrE19pY8mLfUNsSxMt2DxVsshHaHvQ/pKHH+wMmZmhASMw2FpeBt89eSb+t0zdE9wNtmwGitgJIakmbcuoktG7RSTTd2ZZKV2BVlQyFUVlKURLBuysY/qLt/cWJHC1UBIzAbi5xree/NfuzEDyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786955058; c=relaxed/simple;
	bh=UZCLXltPs4BwAyyuM8Wky2JAe/8fPOXetbzfNccmGEk=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S2v5KERumXD22DRJGu6UHikiMRgmYtvHrcx+q1eS2nwNP84BfwqAt9XiH6SAZCYfS1HHCYANfLpMoYljAF1COkUt6PbpDntKEZoawYqLz00xnde89kvkPlwLpawJFzJtOjwJWgETs19tXKY4MSfwW7PEoyocwN0XgUTro5Lxdxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=pyWivpEu; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="pyWivpEu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786955049; bh=mni/bLDdPft8B5Vdc9ecDXfDJ+RjP+Ni6mVe++1JQPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=pyWivpEuP8+cHZOcoNRBay0M/9BKnDEOGYmUTnoGY6CmcRT0alw7yVJ++vNm12vkG
	 U+FjLIbFUzT11vaZ5zu1SwWYATywcGuhbzg/5BKi0CTSUnGd2vUc71i3KDC1rnn2/g
	 m9hvVUbzWqpXN0Gz/3qz+Owt7S2KFXQviUll1XWI=
Received: from DESKTOP-AT5F202.localdomain ([183.242.132.32])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 605BE659; Mon, 17 Aug 2026 16:24:05 +0800
X-QQ-mid: xmsmtpt1786955045tdqw35soj
Message-ID: <tencent_EC4B8D58E1DE43EB21698C43AB0C25F72F08@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuUBe5Mui+GprBeZ9Znw9csvoqBVvyGNpwHD9fdEy0RAE35E/Y+g
	 zuiSvSKH3aU+Ivc9O7glOQ6HOEvmZs/fnBISuHvZfONwfeQZULhw0ITB/7W4phfAxZSI9NB8iHXU
	 wIOFEBtcr+LCCsWdqRFdj2hUNTM6GBSlvrKEZqDncdDnFOjVR+lUSCAzeC5847uhtk388a39UX00
	 YZectdFo4m8O+4YyrI1k+80yT4AJatcdHsBnVcTpElg4dFmPUFJn+rqKbM5r8GxuQeiqNu/YyHxb
	 ceBv8a4tK6E4e9ljIkpgOSyokri3V2sCZriZQ7wOR8RJXQzRKmIU6+PNq3gSJrSYaUjLgWaUPyfU
	 EjGgi1OD2qj4HphKkSWlnM6jkk8I1IhlK5pcAxt7UfBQ20v5DcaClYMON4cUXpJP3iu5lqTSVScs
	 ic2jO8YPF9EnqYtTEt55mwj34+3firSByCnEDbx9qdnIARlpTgmM7UnBySPOoflqNzBlWd9VT0Ye
	 MoPozLkNzHHytto0fTMnj2J7hYeutiKC2W5LYBsa3s6iIeGJz4OHERLHDM7dFv6zOLhor1fbgOFC
	 aki33qhI0L2gSyDDi8mxOSepHU34/9drlBqTAp4jKbPMo2E7cyR7hwC2pda5peRmgr7JUr5wvMYG
	 v+sV7KRjwiHalrk5lGOOl8ZllDb0GB2FVvZZYMGiJ5nR6KTCc0bhLMWor3kPcvsI4D53b9BaqyOi
	 bB8AMC3w1Y4bktGqoMdtcmtHw5mwjjc478i+ML398XEtx5F0g+SGJ32yUeUz7bw55FwwoMXA85Cb
	 q0WWOI5xboXtBmWiOaNNIdRR2piKMPwHAJL9E1RpM9mqgR9vm46OfCr4BeeLGf1DbGgOpTwSUnUZ
	 nfY6CDtEmMtvsj3UZ3rXfwxB8MTq36YOK+nXnZmn3DmAwCeeWQ37y7x0aJJxECwq5QiaFEuIgCJn
	 5FBEgKNv5Qk3Ak6ip3HXhww6EIZAj8JO3o5HHtf3abdN2KobXH2vbNy2A8wLySdqOTWmnxJ82noz
	 RYf7jG6qw9VwFXrIavCiHAPf5ykHM=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
Date: Mon, 17 Aug 2026 16:24:05 +0800
From: shuo chen <1289151713@qq.com>
To: Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ack@suse.cz,
	ojaswin@linux.ibm.com, yi.zhang@huawei.com,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
X-OQ-MSGID: <aoLFJUWi2qTnnXBD@DESKTOP-AT5F202.localdomain>
References: <an5_shcksPF6uIaW@mit.edu>
 <tencent_BDF7C28D876E422418FB57474B765F0C1A09@qq.com>
 <aoJ4bJZNgNAt4pLD@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoJ4bJZNgNAt4pLD@mit.edu>

On Sun, Aug 16, 2026 at 11:12:33PM -0400, Theodore Tso wrote:
> Since you are making changes to inline_data feature, you'd use it
> soemthing like this:
> 
> % cd /usr/src/linux  # replace with your kernel sources
> % install-kconfig
> % kbuild
> % kvm-xfstests -c ext4/inline -g auto

Thank you very much for your detailed guidance on the testing process.
I will fix the issues reported by Sashiko and Syzbot.

> 
> You can also add some options to install-kconfig to enable extra
> debugging, of which the most interesting are --kasan and --lockdep.  I
> would recommend doing your initial testing using just the plain
> install-kconfig, and then once you are getting clean run, do separate
> runs with the Kernel Address Sanitizer and the runtime locking
> correctness validator.

I'll run the tests following your recommended sequence.

> 
> The way I do my testing using gce-xfstests is to use a command like
> this: "gce-xfstests ltm -c ext4/all -g auto" which will launch 12
> VM's, for a variety of ext4 test scenarios (e.g., with bigalloc, fast
> commit, 1k block sizes, etc.)  You can of course try running
> "kvm-xfstests -c ext4/all -g auto" but this will likely take around
> 24-36 hours depending on how fast your local storage test devices.
> (Using gce-xfstest's lightweight test manager takes around 2 hours of
> wall clock time, since the test VM's run in parallel.)

Regarding gce-xfstests, I don't have Google Cloud access at the moment,
but I'll also try running "kvm-xfstests -c ext4/all -g auto" locally to
cover more scenarios.

I'll send the v3 patch along with the test results once everything is
ready.

