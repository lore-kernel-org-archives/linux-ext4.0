From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Metadata Replication for Ext4
Date: Fri, 21 Oct 2011 11:54:28 -0400
Message-ID: <20111021155428.GA21564@infradead.org>
References: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com>
 <alpine.LFD.2.00.1110191553500.29698@dhcp-27-109.brq.redhat.com>
 <FF85E3C6-8AB3-4A63-9E3D-06D06C778CEC@dilger.ca>
 <CAGr1F2GWXd=pfb3JECDwwzd70AczBHb3_yimaRRxmRAe9du_CQ@mail.gmail.com>
 <4EA1952B.9070404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aditya Kali <adityakali@google.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Nauman Rafique <nauman@google.com>,
	TheodoreTso <tytso@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	"Alasdair G.Kergon" <agk@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49808
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847Ab1JUPyb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Oct 2011 11:54:31 -0400
Content-Disposition: inline
In-Reply-To: <4EA1952B.9070404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 21, 2011 at 10:52:11AM -0500, Eric Sandeen wrote:
> With an SSD, you -really- don't know the independent failure domains,
> with all the garbage collection & remapping that they may do, right?

In fact some popular consumer SSDs do some fairly efficient data
de-duplication which completly runs any metadata redundancy on a single
of these devices void.

