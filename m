From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Subject: RE: Is it possible for the ext4/btrfs file system to pass some
 context related info to low level block driver?
Date: Wed, 4 May 2011 18:31:19 +0800
Message-ID: <CE761E84DADF2947A4AF22FB8D97A47358EE523B@shsmsx501.ccr.corp.intel.com>
References: <CE761E84DADF2947A4AF22FB8D97A47358E28022@shsmsx501.ccr.corp.intel.com>
 <BANLkTikm-ZMG7KRjjz0DtduPDC4KUw7_Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab1EDKeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 May 2011 06:34:08 -0400
In-Reply-To: <BANLkTikm-ZMG7KRjjz0DtduPDC4KUw7_Bg@mail.gmail.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Park,

Thanks a lot for the response.

>It seems similar with TRIM. So how about to consider TRIM
>implementation or extend it?

Yes, file system set REQ_DISCARD flag to notify block device driver to execute TRIM.
And I noticed there's already a flag REQ_META used for file system meta data.
But seems only gfs2 file system uses the REQ_META flag, other file systems (including ext4 and btrfs) have not used this flag.
Is the flag useless or any other reason?

>I'm not familiar with NCQ implementation but it's also helpful to implement it.

I don't know much about NCQ, too. Just have a impression that NCQ is only for SATA hard disk, can it also be used for block device, such as the mmc block device?

Thanks.

Regards,
Yunpeng

