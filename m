Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795191534;
	b=dKQB7ECZZlfVoq734qRvvyrTD+7vW4q4j7Ui8/BPNGdbNAPXZEXYylwWPXsWBkla9B+W
	 4r5m5PjCZRVVzhoW+JTCuBwAW+IhIl78gTkqkzBILWPjfGbDxRcbGF7H4s2oaLv527EzW
	 iTbonNDx+GoDh61dXEm9TTZTEisU2l06V7OFAgQlfXNX4JRiISEZRtMM+wLXOParpj/HZ
	 K5DDrSCfQYd1Nsve9xPSWJlEMbItyMkHKGsmmHKUhGxHYHFCTRAMQn2PkR2POq9hDmayt
	 oosXDkXn68x+Sy3KMUnRnXDvGo6PAExhFDHp+QuqKy+Gje5MWUR0OxIR5Z8R93z8rJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795191534;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=oKauJt9tjqZQag9vgF8/EwdJZLqiOLyjqwONZtCX9wg=;
	b=M0o9hqe5W9jbKlW/Idw9SzMiX+7LvIrCQzeKWk2zHVfIJwYiMysIWoWmBMuHD7XdzTF4
	 Aej9vDFPvlVqweLCQcBcy9+o5hC0QSlP2I66Dk+Y1jzo7/hfFpljrrEjeDluFROO8l5/s
	 lskguxRUs8BB84YleEiNuQi9+Em+QzRcMrGVmEEpvgiRJIzNPtSIryKYcSYKWb9vInOvk
	 +Y+NhWureN7ScyEigKbW03h4mVDv1t5kXCfoj56eLFexmb9rRyeaEx2anXizJ30apsO24
	 wU/RdNVELcKyGECxu6Nzht07LEsmT1GyxUtWMGJAQf9khvrHX/TmHnc1VEHuRlzTa7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cYv0nzp0;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44A1606A325
	for <linux-ext4@vger.kernel.org>; Fri, 20 Nov 2026 16:18:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B44A1606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=cYv0nzp0
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AKGHtZP019206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Nov 2026 11:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795191481; bh=oKauJt9tjqZQag9vgF8/EwdJZLqiOLyjqwONZtCX9wg=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=cYv0nzp0A3i/S5R85oW19q/2cOhwRyF5FFtur6Dv3tIOLD6JQVcCKa4r3ThAuabNW
	 INQObOkzro2qJCbBxIRepoeRhTqzJJPq7XBHtKVRsBiBrsmbjrgXItaES/vWpQT9qO
	 e+OvtY5nAav8+3nedGE1vKipZ3119hBnDEZnvj2lNnQ3liXCExY/qhqLI11yDcji1F
	 ETuNMXhDzFXi2bXmhYozQjBTLFxSxLb6NvRHlohdfVxvCAgNZgnydKQNZAWiQY51mM
	 JfbYAf5XFpJoSBXQzGN26kuusAbGN7e0rdMI8p7hpkOb3yybXUdbRRgc0wz2zbV60K
	 RVBmxBpoAdJLw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 774A32893533; Fri, 20 Nov 2026 11:17:55 -0500 (EST)
Date: Fri, 20 Nov 2026 11:17:55 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Yichong Chen <chenyichong@uniontech.com>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, guanwentao@uniontech.com,
        niecheng1@uniontech.com, Morduan Zang <zhangdandan@uniontech.com>
Subject: Re: [PATCH] ext4: keep ordered data and i_disksize consistent on
 size changes
Message-ID: <awBwutTXygOERsY-@mit.edu>
References: <D7EEAE1F0CDD3029+20261118075044.3511841-1-chenyichong@uniontech.com>
 <f5fv5eyvkpeqtopmigq5q7cd6265ptu3jn4xqwglhhsrcxorop@z3buh3cwimvn>
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
In-Reply-To: <f5fv5eyvkpeqtopmigq5q7cd6265ptu3jn4xqwglhhsrcxorop@z3buh3cwimvn>

On Fri, Nov 20, 2026 at 01:02:24PM -0500, Jan Kara wrote:
> Yes, and as the LLM probably told you these checks are failing on ext4 for
> ages and no real user complained. Ted may have a different opinion but I
> don't think we care about fixing them, in particular given the costs in
> complexity of i_size updates and also performance of appending writes /
> truncate.

Yes.  In addition, there was never any data integrity guarantees of
data=ordered.  The main reason why this exists is to avoid any stale
data belonging a deleted file (which might be someone's PII, love
letters, offers to sell GPU's to export-restricted countries, etc.).
If the application wants data integrity guarantees, it should use
fsync(2).

The only reason why we have data=ordered is because we use the order
of operations from ext2 --- namely, first we allocate the block, then
we insert the block mapping into the inode, and then we write the data
to the newly allocated block.  Once we change things so that we write
the data block to the newly allocated block, and *then* we make the
metadata change, we can unify data=ordered and data=writeback; and
then once data=journal gets deprecated, all of the data=xxx mount
options will go away, and there will be only one way that we handle
writeback.

						- Ted
