From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: What should be the optimum value of G (number-of-groups) when using flex_bg?
Date: Wed, 7 Nov 2012 05:02:25 -0700
Message-ID: <701D25F0-1D33-420C-8D5C-C65734E32E13@dilger.ca>
References: <CAOiN93nrrFHZpcBHih-ySa8FNMdOp4gTgzjVPXWKPYSABgHMMw@mail.gmail.com> <CAOiN93nGvYNZUiNRq23ThDU+sYmooAgjjTfYode3vdXna2E7fg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Namjae Jeon <linkinjeon@gmail.com>, linux-ext4@vger.kernel.org
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:12812 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2KGMC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Nov 2012 07:02:26 -0500
In-Reply-To: <CAOiN93nGvYNZUiNRq23ThDU+sYmooAgjjTfYode3vdXna2E7fg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-11-05, at 9:36 PM, Ashish Sangwan wrote:
> We have a 2TB HDD which we formated using default options of mkfs.ext4(v1.42.6).
> I took around ~15 seconds to complete this operation.
> 
> Than we formatted the same partition with "-G 1024" and there was
> around 30% performance improvement in
> the mkfs.ext4 timings.
> 
> Than, out of curiosity, we increased the G's value to 1048576 and
> there was a drastic degradation in the performance of mkfs.ext4.
> It took more than 5 minutes to complete the execution.
> 
> Is it the expected behavior?

The optimum number is very workload specific.  We use "-G 256" and
a few other options so that the number of metadata blocks per group
is a multiple of 1MB and aligned on 1MB boundaries.  This is for
optimized IO on RAID-6 storage that has good IO performance with 1MB
chunk sizes.

> AFAIK flex_bg is on by default with G's vaule as 16. Can we consider
> this the optimum value?
> 
> Any suggesstions on what  we can set the Gs value for a 2TB HDD such
> that both the FS and the
> mkfs.ext4 gives optimum performance?
> It would be really helpful if somebody can shed some light over this feature.
> 
> Thanks,
> Ashish


Cheers, Andreas





