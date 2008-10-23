From: Solofo.Ramangalahy@bull.net
Subject: gcov for ext4
Date: Thu, 23 Oct 2008 13:00:56 +0200
Message-ID: <18688.22888.7142.335388@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Peter.Oberparleiter@de.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45342 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbYJWLH4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Oct 2008 07:07:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

While doing the fs_mark measurements, and with ext4 in 2.6.28, I
looked back at what a test plan would be for ext4.
I tried again gcov with the help of Peter (I was hoping that it would
become mainline with 2.6.28).

Here are the results:
http://www.bullopensource.org/ext4/20081020-gcov/

While I do not share the idea that 100% coverage is a requirement, I
found it useful the show obvious holes in a test suite and as an
indication for the test effort.

-- 
solofo
