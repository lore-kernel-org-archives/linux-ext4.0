From: Frank Mayhar <fmayhar@google.com>
Subject: /proc->/sys change.
Date: Thu, 26 Mar 2009 09:45:58 -0700
Message-ID: <1238085958.22887.7.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:61794 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbZCZQqF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Mar 2009 12:46:05 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id n2QGk1TY018266
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2009 09:46:02 -0700
Received: from [172.29.60.126] (bobble.smo.corp.google.com [172.29.60.126])
	(authenticated bits=0)
	by wpaz29.hot.corp.google.com with ESMTP id n2QGjwO0012183
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2009 09:46:00 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We just noticed that the patches that added sysfs support and
subsequently removed procfs support left two files in /proc.  The
mb_history and mb_groups file appear to have been overlooked in this
process.  Or was this intentional?

In any event, this is a heads-up.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

