From: Frank Mayhar <fmayhar@google.com>
Subject: Re: Concise description of disk layout?
Date: Fri, 17 Apr 2009 11:49:26 -0700
Message-ID: <1239994166.7799.24.camel@bobble.smo.corp.google.com>
References: <1239838392.12688.4.camel@bobble.smo.corp.google.com>
	 <20090416002809.GG21586@mit.edu>  <gsahsj$8tk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:53166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549AbZDQSt3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Apr 2009 14:49:29 -0400
Received: from zps75.corp.google.com (zps75.corp.google.com [172.25.146.75])
	by smtp-out.google.com with ESMTP id n3HInSsK015274
	for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 11:49:28 -0700
Received: from [172.29.60.126] (bobble.smo.corp.google.com [172.29.60.126])
	(authenticated bits=0)
	by zps75.corp.google.com with ESMTP id n3HInQv0032613
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2009 11:49:27 -0700
In-Reply-To: <gsahsj$8tk$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2009-04-17 at 18:30 +0000, Frank Mayhar wrote:
> Sorry for the late reply.
> 
> On Wed, 15 Apr 2009 20:28:09 -0400, Theodore Tso wrote:
> >    http://e2fsprogs.sourceforge.net/ext2intro.html
> > 
> > but updated for ext4?
> 
> Yeah, the "Physical Structure" section.

I've read through some of the documents you pointed to and it sounds
like the actual on-disk format hasn't changed significantly, i.e. block
groups are laid out in basically the same way and the stuff within them
is laid out in more or less the same way as in ext2/ext3; the major
difference seems to be the allocation strategies embedded in the code
itself.  The new strategies simply mean that files and inodes are
allocated more efficiently but not really in new places.  Is this (more
or less) correct or am I totally off-base?
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

