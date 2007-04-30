From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (April 23, 2007)
Date: Mon, 30 Apr 2007 15:13:47 +0400
Message-ID: <4635CF6B.6000500@clusterfs.com>
References: <462D42CA.50509@linux.vnet.ibm.com> <cc723f590704300406l5c3a8a84y2cd3aecd52209c2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Aneesh Kumar <aneesh.kumar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.rialcom.ru ([80.71.245.247]:49766 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbXD3LPI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2007 07:15:08 -0400
In-Reply-To: <cc723f590704300406l5c3a8a84y2cd3aecd52209c2b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar wrote:
> What i am doing for creating a large number of extents is
> 
> dd if=/dev/zero of=myfile count=10
> seek=20
> while [ 1 ]; do dd if=/dev/zero of=myfile count=10 seek=$seek;
> seek=`expr $seek + 20`; done

with AGGRESSIVE_TEST defined in include/linux/ext4_fs_extents.h you may
get much more extents and index blocks.
