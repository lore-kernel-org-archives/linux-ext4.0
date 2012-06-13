From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] e2image: add -a switch to include all data
Date: Wed, 13 Jun 2012 16:41:12 -0400
Message-ID: <4FD8FAE8.3030002@ubuntu.com>
References: <1329841206-14769-1-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:15286 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2FMUlO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2012 16:41:14 -0400
In-Reply-To: <1329841206-14769-1-git-send-email-psusi@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey Ted, I still haven't heard anything about this.  Do you not like the 
patch?

On 2/21/2012 11:20 AM, Phillip Susi wrote:
> Normally the raw and QCOW2 images only contain fs metadata.
> Add a new switch ( -a ) to include all data.  This makes it
> possible to use e2image to clone a whole filesystem.
>
> Signed-off-by: Phillip Susi<psusi@ubuntu.com>
