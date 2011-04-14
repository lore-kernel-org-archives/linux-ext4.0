From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 14 Apr 2011 11:31:08 -0500
Message-ID: <4DA7214C.4070602@sandeen.net>
References: <20110414102608.GA1678@x4.trippels.de> <20110414120635.GB1678@x4.trippels.de> <20110414140222.GB1679@x4.trippels.de> <4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net> <4DA7182B.8050409@draigBrady.com> <4DA71920.9@sandeen.net> <20110414160343.GA12787@x4.trippels.de> <BANLkTimRxvBMp9M7zwiUY_UmmFOY5N58+A@mail.gmail.com> <20110414162856.GA21658@x4.trippels.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	=?ISO-8859-1?Q?P=E1draig_Br?= =?ISO-8859-1?Q?ady?=
	<P@draigbrady.com>, xfs-oss <xfs@oss.sgi.com>,
	linux-ext4@vger.kernel.org, coreutils@gnu.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50827 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1DNQbK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Apr 2011 12:31:10 -0400
In-Reply-To: <20110414162856.GA21658@x4.trippels.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/14/11 11:28 AM, Markus Trippelsdorf wrote:

<snip>

> Yes, but we're still trying to find out what caused the zeros in the
> binaries that coreutils installed on my system.
> 
> Now the failure only happens when I use "gold" as my linker. With GNU ld
> everything is OK. But I thought this must be a timing issue, because
> gold is faster and the binaries in coreutils-8.11/src are all fine.

maybe xfs_bmap (or filefrag) of the binaries with both linkers would be instructive; are they laid out significantly differently?

does gold preallocate?

-Eric
