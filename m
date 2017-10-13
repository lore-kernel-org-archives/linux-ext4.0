From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 17/19] ext4: Add support for MAP_SYNC flag
Date: Fri, 13 Oct 2017 08:52:28 -0700
Message-ID: <CAPcyv4g+YE4D0-_Y=yxa2s8Ns8F89=HdY=-_Pg_gYxcXtZ8tTg@mail.gmail.com>
References: <20171011200603.27442-1-jack@suse.cz> <20171011200603.27442-18-jack@suse.cz>
 <CAPcyv4gZw0QCG08Qs8dP8TMhgXo0_KcVq-33uhaG8QuwxXT=Wg@mail.gmail.com> <20171013072224.GG9105@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ted Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:46387 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758286AbdJMPwa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Oct 2017 11:52:30 -0400
Received: by mail-oi0-f53.google.com with SMTP id n82so14987185oig.3
        for <linux-ext4@vger.kernel.org>; Fri, 13 Oct 2017 08:52:29 -0700 (PDT)
In-Reply-To: <20171013072224.GG9105@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 13, 2017 at 12:22 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Oct 11, 2017 at 03:11:21PM -0700, Dan Williams wrote:
>> > +       /*
>> > +        * We don't support synchronous mappings for non-DAX files. At least
>> > +        * until someone comes with a sensible use case.
>> > +        */
>> > +       if (!IS_DAX(file_inode(file)) && (map_flags & MAP_SYNC))
>> > +               return -EOPNOTSUPP;
>>
>> Perhaps EPERM instead to differentiate the unsupported flags case?
>> There's precedent for mmap returning EPERM for reasons other than
>> incompatible PROT flags.
>
> Why would we want to voluntarily use arcane errors for a entirely
> new interface under our control?
>
> -EOPNOTSUPP is nice and explicit about what is going on.

We have this general and perennial problem of parsing why the kernel
is throwing an error. It saves a debug step if the error code is
unique, and in this case would indicate that the filesystem supports
MAP_SYNC but the administrator failed to arrange for the device to be
in DAX mode.
