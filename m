From: Andreas Dilger <adilger@sun.com>
Subject: Re: Errors reported by Coverity in ext3
Date: Mon, 13 Apr 2009 16:02:40 -0600
Message-ID: <20090413220240.GT17302@webber.adilger.int>
References: <18730dc50904120458m1649aaf7tab395436d159105a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Amir Goldor <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:58305 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbZDMWDg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Apr 2009 18:03:36 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3DM3NG0024097
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2009 15:03:36 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KI200A007SJ4L00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 13 Apr 2009 15:03:23 -0700 (PDT)
In-reply-to: <18730dc50904120458m1649aaf7tab395436d159105a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 12, 2009  14:58 +0300, Amir Goldor wrote:
> in reply to your message from 2006
> (http://marc.info/?l=linux-ext4&m=116310729115980&w=2)
> I have prepared a small patch to check jbd errors on 4 occurrences in namei.c
> could you please review my patch

Could you please regenerate your patch with "diff -up" so that the
function names are included into the patch context.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

