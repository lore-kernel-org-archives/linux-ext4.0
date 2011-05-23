From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: don't check/clone duplicate xattr blocks in fs
 without xattr feature
Date: Mon, 23 May 2011 13:00:39 -0500
Message-ID: <4DDAA0C7.7050204@redhat.com>
References: <4D52DFE7.4050301@redhat.com> <4D77EAAC.3010208@redhat.com> <4DDA9ECA.8000708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531Ab1EWSAl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 14:00:41 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4NI0eqH011544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 14:00:41 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p4NI0dng001432
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 14:00:40 -0400
In-Reply-To: <4DDA9ECA.8000708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/23/11 12:52 PM, Eric Sandeen wrote:

> Ping again, for review and/or merge of this one, it's approaching 4 months old now...
> 

Actually I'll rebase & resend now.
