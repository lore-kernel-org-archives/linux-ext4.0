From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: [RFC] [patch 0/2] i_version update
Date: Mon, 14 May 2007 13:04:51 +0200
Message-ID: <1179140691.7733.2.camel@frecb002711.frec.bull.fr>
Reply-To: jean-noel.cordenner@bull.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48097 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbXENLJu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2007 07:09:50 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id B749819D925
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 13:09:50 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 04590-08 for <linux-ext4@vger.kernel.org>;
 Mon, 14 May 2007 13:09:47 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id A163E19D92B
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 13:09:47 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This is an update of the i_version patch.
The i_version field is a 64bit counter that is set on every inode
creation and that is incremented every time the inode data is modified
(similarly to the "ctime" time-stamp).
The aim is to fulfill NFSv4 requirements for rfc3530.

The patch set is divided into 2parts, the vfs layer and a ext4 specific
code.

Any comments welcome.

Cheers,
Jean noel
