From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] sparc: Export needed symbol for ZERO_PAGE usage in
 modules.
Date: Mon, 24 Mar 2008 13:34:45 -0700 (PDT)
Message-ID: <20080324.133445.229184630.davem@davemloft.net>
References: <1206381777-12671-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57400
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751679AbYCXUep (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Mar 2008 16:34:45 -0400
In-Reply-To: <1206381777-12671-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Mon, 24 Mar 2008 23:32:57 +0530

> ext4 use ZERO_PAGE(0) to zero out blocks. We need to export
> different symbols in different arch for the usage of ZERO_PAGE
> in modules.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Merge this in with the necessary ext4 changes, and no
sooner.
