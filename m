From: Frank Mayhar <fmayhar@google.com>
Subject: Concise description of disk layout?
Date: Wed, 15 Apr 2009 16:33:12 -0700
Message-ID: <1239838392.12688.4.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:50622 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZDOXdP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Apr 2009 19:33:15 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id n3FNXE3g032489
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2009 16:33:15 -0700
Received: from [172.29.60.126] (bobble.smo.corp.google.com [172.29.60.126])
	(authenticated bits=0)
	by wpaz21.hot.corp.google.com with ESMTP id n3FNXCMe026891
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2009 16:33:13 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Does such a thing exist anywhere?  I.e. "inodes are here, data blocks
are here, etc., etc."  I need to come up with something like this but if
one already exists that would save a lot of time.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

