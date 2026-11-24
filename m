Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795532195;
	b=Sklq8Vz4Kq1hKsTj9H4AlzZGO+X59etS5EWCPqg/Rbcxt+Uah+rS6WJxqNa49szCoXXH
	 SOAB/98iSg48wih/D0NxrtHJhdDE2PuGlpnseO+Iy/pG5qcra4dHJRC1QqS/UJD0MOHfE
	 3XtTHX2+8xihIBS9eUIz6tb23JqGskaEABDWCmqd5EmY896Q5kZ04BNyELE+mLuGJ3spC
	 7zShu08UgVXS3QNAyDfVhPzLu8fINefZGvmzswvjR7Uh0hOmHWzEozVA/7cqokxkDdRbF
	 3UtQvDU9BnOuTB+TaCBASBCnOIpuo6PhAVz24xCjveWv2PK0V0h6iuvpHIhqEDJTtxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795532195;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=/AUkC4hONDgD6ntHPObWNT7fhuOS0myZax3gE4i18kI=;
	b=G180NLOsvUpu6Z4R9KTR09j7qrTnhbGhrkomxhgGbU7LWTD068NYq2m6RxDpcPCE9+V7
	 RSzlMZG/WrzzTFqufkt9AuexTHR23xCoxT6dUdxrymWu7FcKvXGmsJkP1De8pH4ZCsEG6
	 q2FDEr3HTf8qMAs+6kDkVEAN2B0sVPwwTNsYSp4n4+L44h+hXdfZg9EJksh2ctJvM9Ahv
	 pQ/bzpSo5eilrjTdva1tCUmr43VigURqfgmfgJn0LLHMlfAwJT5NmlY71SIULUazCOkT0
	 y7NWaEOs+XhjhAv3KWLMKD8bmwXXSjCjYhPU7apw3ZRRlBQhU8GyO+Ofq1CC4pqLRzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=f5NvEFVA;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3052606A31E
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 14:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3052606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=f5NvEFVA
Received: from macsyma.thunk.org (pool-173-48-102-184.bstnma.fios.verizon.net [173.48.102.184])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AOEtUao020827
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 09:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795532133; bh=/AUkC4hONDgD6ntHPObWNT7fhuOS0myZax3gE4i18kI=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=f5NvEFVAjHeAdRryr5U7XKmkGkpVYoTT/WlXHM0Fy46Z93JRUSYXcOFCwnsA61J/O
	 9LTrcIdsLdNGKroP4VpNk51XHjHqFZ/4HRUhJaFf/DP+25ryNvi7APAl2G2rTVGCkF
	 i9vXoJtp4CPdJeUEjFrhqT14XBXtZK1Oa0ntEqK697pe71AAbRzxBlZZnT1bEAKq4t
	 XCdfKDBRo2rOxiAemWhs1Iap021SQdPqzFYqlotsYxtMejzQxGPyyU4RuqkqYD9BLK
	 2rE4ae2JZS4DruNP574zt0dzQpew39/GA+j5H8bO1yubn5Mhs7IRTBVczPAJLb7nsy
	 uBATV51CE6e3w==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 29EE4291FE50; Tue, 24 Nov 2026 09:55:30 -0500 (EST)
Date: Tue, 24 Nov 2026 09:55:30 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com
Subject: Re: [PATCH v4 0/2] ext4: reject impossible group free cluster counts
Message-ID: <awWhtXvIgTk1QzuY@mit.edu>
References: <20261124033900.76700-1-zhaogongyi@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124033900.76700-1-zhaogongyi@bytedance.com>

On Tue, Nov 24, 2026 at 11:38:58AM -0500, Zhao Gongyi wrote:
> ext4 initializes its free-space counters from the group descriptors. A
> corrupt descriptor can advertise more free clusters than its group can
> hold. Journal block replay can also replace the superblock and group
> descriptors that were examined when mounting.
> 
> This series adds an optional JBD2 recovery callback and uses it in ext4
> to validate the recovered geometry and group descriptors. It checks the
> metadata before fast commit replay and checks the descriptors again
> after fast commit replay. Both halves of the group free-cluster count
> are read under the group lock.

Note: in the future, could you send your patches so that each of the
patches are sent as a reply to the cover letter, so becomes easy to
find all of the patches associated with the patch series?  This makes
life much easier for patch reviews, and it also allows me to use the
"b4" command to gether up and apply all of the patches once the patch
review is complete.

The way I do that is to put in my ~/.gitconfig:

[sendemail]
	chainreplyto = no
	thread = yes

See the discussion of the --thread and --[no-]chain-reply-to options
in the man pages for git-send-mail and git-format-patch for more details.

Many thanks!

       	   	     		       - Ted
