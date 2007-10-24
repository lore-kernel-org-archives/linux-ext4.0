From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Fix ext4_show_options to show the correct mount
 options.
Date: Wed, 24 Oct 2007 12:55:17 -0500
Message-ID: <471F8705.9090308@redhat.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbXJXRzw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2007 13:55:52 -0400
In-Reply-To: <1193244441-10149-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:
> We need to look at the default value and make sure
> the mount options are not set via default value
> before showing them via ext4_show_options

Hm, does this jive with the comment about what's intended?

/*
 * Show an option if
 *  - it's set to a non-default value OR
 *  - if the per-sb default is different from the global default
 */

Aren't you now omitting the option if it's set in the per-sb default?

For example the "debug" option; it's off by default, globally.  The
above comment suggests that if you have overridden that global default
in the per-sb "default mount options" then it should be shown; this sort
of makes sense to me because tune2fs calls these "default mount
options," I'd expect them to behave exactly as if you had explicitly
mounted with them.

With your patch, if you've set debug as default, it no longer shows up,
right?

-Eric
