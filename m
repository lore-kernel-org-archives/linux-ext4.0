From: Jean noel Cordenner <jean-noel.cordenner@bull.net>
Subject: Re: [PATCH 1/2]  i_version update - vfs part
Date: Tue, 20 Nov 2007 17:38:30 +0100
Message-ID: <47430D86.3070801@bull.net>
References: <1191598088.24615.45.camel@frecb002711.frec.bull.fr>	 <1193331870.5487.31.camel@frecb002711.frec.bull.fr> <1193346351.4288.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55915 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXKTQnb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2007 11:43:31 -0500
In-Reply-To: <1193346351.4288.16.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Here you can find some performance comparison in terms of CPU 
utilization and transactions per second (using FFSB) on ext4 filesystem 
with and without i_version option.

http://bullopensource.org/ext4/20071116/ffsb-write.html

regards,
Jean noel
