From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Revised Ext4 Punch Hole patches
Date: Tue, 15 Mar 2011 14:17:11 -0700
Message-ID: <4D7FD757.6010700@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38041 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1COVRP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 17:17:15 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2FL6WCR028611
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:06:32 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2FLHCTO093192
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:17:12 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2FLHCYh027308
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:17:12 -0600
Received: from [127.0.0.1] (IBM-3CEFE379E05.tucson.ibm.com [9.11.169.120])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p2FLHBfN027285
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2011 15:17:12 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All!

This is my second pass at the Ext4 punch hole support patch set.  I've 
integrated everyone's feedback, and there have been a lot of changes 
since the last set.  Also, I understand that others are also working on 
routines similar to the helper routines in patch 1.  Once we get all our 
common code worked out, these routines will likely be replaced by the 
general purpose routines that we come up with later.  Thx all for your 
feed back.

Allison Henderson

