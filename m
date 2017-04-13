From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 2/4] e2fsprogs: add support for 3-level htree
Date: Thu, 13 Apr 2017 11:57:35 -0400
Message-ID: <20170413155735.avp33xjuwdkfqydg@thunk.org>
References: <20170215054247.GA6804@birch.djwong.org>
 <1487180595-900-1-git-send-email-artem.blagodarenko@gmail.com>
 <5EA450CA-91D0-4D57-A130-426D33953B1D@dilger.ca>
 <2716C539-8479-4213-B76E-392E595B183D@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        darrick.wong@oracle.com,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: =?utf-8?B?0JHQu9Cw0LPQvtC00LDRgNC10L3QutC+INCQ0YDRgtGR0Lw=?=
        <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34302 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754222AbdDMP5h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Apr 2017 11:57:37 -0400
Content-Disposition: inline
In-Reply-To: <2716C539-8479-4213-B76E-392E595B183D@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've applied the latest version of these patches to the next branch.
My plan is to release 1.43.5 on the maint branch, and the 3-level
htree will be for an eventual 1.44 release (as it is a new feature).

Cheers,

					- Ted
