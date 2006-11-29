From: Jean-Noel Cordenner <jean-noel.cordenner@bull.net>
Subject: [RFC] [patch 0/3] change attribute for ext4
Date: Wed, 29 Nov 2006 19:54:05 +0100
Message-ID: <456DD74D.3040004@bull.net>
References: <20060913164202.GA14838@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:61830 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S967534AbWK2SxB
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 13:53:01 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id CAE5019D91C
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 19:52:55 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21645-01 for <linux-ext4@vger.kernel.org>;
 Wed, 29 Nov 2006 19:52:50 +0100 (CET)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 5754119D924
	for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2006 19:52:50 +0100 (CET)
To: linux-ext4@vger.kernel.org
In-Reply-To: <20060913164202.GA14838@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

I've updated the change attribute patch for ext4 that was initially posted by 
Alexandre Ratchov.

The change attribute is a simple counter that is set on inode creation and that 
is incremented every time the inode data is modified (similarly to the "ctime" 
time-stamp) and never reset.

Here are the results of tests I ran with and without the change attribute patch.

     http://www.bullopensource.org/ext4/change_attribute/index.html


Any comments are welcome.

regards,
Jean noel
