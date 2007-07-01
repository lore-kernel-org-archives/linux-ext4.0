From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
Date: Sun, 1 Jul 2007 04:26:19 -0500
Message-ID: <20070701042619.2215645f@gara>
References: <1183275490.4010.134.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49246 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbXGAJ1c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jul 2007 05:27:32 -0400
In-Reply-To: <1183275490.4010.134.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:38:10 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> [PATCH] jbd2 stats through procfs
> 
> The patch below updates the jbd stats patch to 2.6.20/jbd2.
> The initial patch was posted by Alex Tomas in December 2005
> (http://marc.info/?l=linux-ext4&m=113538565128617&w=2).
> It provides statistics via procfs such as transaction lifetime and size.
> 
> [ This probably should be rewritten to use debugfs?   -- Ted]

Was a decision ever made on whether this should remain on procfs or be
move to use debugfs?  I can recall this being discuss but don't recall
a firm decision on it.

-JRS
