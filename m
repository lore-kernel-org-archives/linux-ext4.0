From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsck repeatedly asks to clear the same entry?
Date: Sat, 24 Nov 2012 11:34:56 -0600
Message-ID: <50B10540.1060405@redhat.com>
References: <k8of5a$sjb$1@ger.gmane.org> <07FA29B6-B150-4A93-B6FF-3072DF31B577@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mark Casey <markc@unifiedgroup.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab2KXRe6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Nov 2012 12:34:58 -0500
In-Reply-To: <07FA29B6-B150-4A93-B6FF-3072DF31B577@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/23/12 1:18 PM, Andreas Dilger wrote:
> On 2012-11-23, at 11:26, Mark Casey <markc@unifiedgroup.com> wrote:
>> I'm in a bit of a loop trying to fix my ext4 filesystem; it always
>> goes like this even after several passes.

...

> Normally I'd say that getting a e2image of the filesystem would be
> useful for debugging and to create a test case, but since the
> filesystem is 16TB in size that won't be practical.

It might not be that bad.  You could make a raw e2image, mount it,
remove some of the non-affected dir trees, (maybe make another e2image -r
of that modified image), and it might compress pretty well.

Just a thought, if the email debugging doesn't yield results.

-Eric
