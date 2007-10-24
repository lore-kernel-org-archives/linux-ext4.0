From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Fix ext4_show_options to show the correct mount
 options.
Date: Wed, 24 Oct 2007 13:25:15 -0500
Message-ID: <471F8E0B.7070202@redhat.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <471F8705.9090308@redhat.com> <471F8C67.2020907@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019AbXJXS32 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2007 14:29:28 -0400
In-Reply-To: <471F8C67.2020907@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:

> So my understanding was that we are supposed to make /proc/mounts show the same output as
> /etc/mtab did. In that case should we be showing the the default set in super block ?
> 
> -aneesh


Hm, well, it's true that they would not show up in mtab... but to me
it's logical that "default mount options" set via tunefs *should* show
up as options if they are not set to fs defaults.  And using
/proc/mounts has the advantage that they *can* show up.

I guess I'm not sure of the pros or cons of either approach.  :)

-Eric
