From: jehan procaccia <jehan.procaccia@it-sudparis.eu>
Subject: howto downgrade ext4 to ext3
Date: Fri, 18 Sep 2009 16:52:53 +0200
Message-ID: <4AB39EC5.6070107@it-sudparis.eu>
Reply-To: jehan.procaccia@it-sudparis.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:59726 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZIROwz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Sep 2009 10:52:55 -0400
Received: from smtp2.int-evry.fr (smtp2.int-evry.fr [157.159.10.45])
	by smtp4.int-evry.fr (Postfix) with ESMTP id A33DAFE1CDA
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 16:52:58 +0200 (CEST)
Received: from smtp-ext.int-evry.fr (smtp-ext.int-evry.fr [157.159.11.17])
	by smtp2.int-evry.fr (Postfix) with ESMTP id 08243404FB0
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 16:52:55 +0200 (CEST)
Received: from [157.159.50.197] (PAT7414.micro.int-evry.fr [157.159.50.197])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-ext.int-evry.fr (Postfix) with ESMTP id AC4C490131
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2009 16:52:54 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

some of you might have followed my miseries about quota support and ext4 ...
http://marc.info/?l=linux-ext4&m=125320312905576&w=2

Apparently the only sure and secure solution offered to me is to 
downgrade my ext4 FS to ext3 :-( .
now , is there a procedure to do that ?
thanks .
