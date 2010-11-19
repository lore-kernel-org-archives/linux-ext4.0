From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
Date: Fri, 19 Nov 2010 10:24:52 -0500
Message-ID: <4CE696C4.4030309@teksavvy.com>
References: <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com> <4CE59E57.2090009@teksavvy.com> <yq1r5eiw5os.fsf@sermon.lab.mkp.net> <4CE5C616.7070706@teksavvy.com> <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com> <20101119115516.GA1152@infradead.org> <4CE6831E.4020606@teksavvy.com> <20101119140639.GA25488@infradead.org> <4CE68E2C.9070101@teksavvy.com> <20101119145423.GA27919@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Jeff Moyer <jmoyer@redhat.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:36150 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754847Ab0KSPYy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 10:24:54 -0500
In-Reply-To: <20101119145423.GA27919@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10-11-19 09:54 AM, Christoph Hellwig wrote:
> On Fri, Nov 19, 2010 at 09:48:12AM -0500, Mark Lord wrote:
>> I'm not sure about the issues on "adapting the block layer" ?
>> For FITRIM, the blocks being trimmed would be reserved at the fs level,
>> before issuing the discard for them.  So ordering through the block layer
>> shouldn't matter much for it.  Does that simplify things?
>>
>> I see FITRIM just allocating a page to hold the ranges (for the>1 case)
>> and passing that page down through the layers to libata (or any other
>> LLD that supports>1 ranges).
>
> Ordering should not be an issue.  What were problems when I tried this
> before is that we currently assume in the block layer that discard
> bios have a valid bi_sector/bi_size, which is already needed e.g. for
> the trivial remapping use for partitions and that they don't have
> a payload.  You'd need to teach various places that discard payloads
> may have a payload, which contains multiple ranges that have a
> sector/len tuple that needs to be remapped and checked in various
> places.

I wonder if this can be treated more like how SG_IO does things?
The SG_IO mechanism seems to have no issues passing through stuff
like this, so perhaps we could implement something in a similar fashion?

-ml
