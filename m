From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 2/2] xfstest: fsstress add EXT2_IOC_{SET, GET}FLAGS operations
Date: Wed, 19 Oct 2011 14:48:28 +0400
Message-ID: <874nz5xnnn.fsf@dmbot.sw.ru>
References: <1316357699-22692-1-git-send-email-dmonakhov@openvz.org> <1316357699-22692-2-git-send-email-dmonakhov@openvz.org> <1317820840.2226.12.camel@doink> <87ty7m327v.fsf@dmbot.sw.ru> <20111019092846.GA3083@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aelder@sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39744 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab1JSKsc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Oct 2011 06:48:32 -0400
In-Reply-To: <20111019092846.GA3083@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 19 Oct 2011 05:28:46 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> Dmitry,
> 
> and updates on these patches?
I've posted new version here:
http://article.gmane.org/gmane.comp.file-systems.ext4/28602

Update for set flags patch now is named:
[PATCH 4/8] xfstests: fsstress add FS_IOC_{SET,GET}FLAGS operations

But still, ext4 panic in case of ordered+delalloc=>journalled switch
"-f setattr=1", i've not posted fix for that bug yet, so please run
this test carefully.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
