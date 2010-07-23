From: Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH V3 0/8] Cleancache: overview
Date: Fri, 23 Jul 2010 20:35:18 +0530
Message-ID: <4C49AFAE.1070300@vflare.org>
References: <20100621231809.GA11111@ca-server1.us.oracle.com4C49468B.40307@vflare.org> <840b32ff-a303-468e-9d4e-30fc92f629f8@default 20100723140440.GA12423@infradead.org> <364c83bd-ccb2-48cc-920d-ffcf9ca7df19@default>
Reply-To: ngupta@vflare.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
	Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
	adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
	Joel Becker <joel.becker@oracle.com>, matthew@wil.cx,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
	JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
	npiggin@suse.de, Dave Mccracken <dave.mccracken@oracle.com>,
	riel@redhat.com, avi@redhat.com,
	Konrad Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55996 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0GWPE6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Jul 2010 11:04:58 -0400
In-Reply-To: <364c83bd-ccb2-48cc-920d-ffcf9ca7df19@default>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/23/2010 08:14 PM, Dan Magenheimer wrote:
>> From: Christoph Hellwig [mailto:hch@infradead.org]


>> Also making the ops vector global is just a bad idea.
>> There is nothing making this sort of caching inherently global.
> 
> I'm not sure I understand your point, but two very different
> users of cleancache have been provided, and more will be
> discussed at the MM summit next month.
> 
> Do you have a suggestion on how to avoid a global ops
> vector while still serving the needs of both existing
> users?

Maybe introduce cleancache_register(struct cleancache_ops *ops)?
This will allow making cleancache_ops non-global. No value add
but maybe that's cleaner?

Thanks,
Nitin
