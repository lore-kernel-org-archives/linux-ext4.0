From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH -V2] ext4: Validate extent details only when read from
 the disk
Date: Wed, 18 Feb 2009 11:10:51 +0100
Message-ID: <499BDEAB.6080807@ph.tum.de>
References: <1234805202-6922-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1234805202-6922-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:57384 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbZBRKLG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 05:11:06 -0500
In-Reply-To: <1234805202-6922-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Make sure we validate extent details only when read from the disk.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Your patches work well for my test case.

Kind regards,

Thiemo
