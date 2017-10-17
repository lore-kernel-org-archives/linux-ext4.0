From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 01/19] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Date: Tue, 17 Oct 2017 12:38:14 -0700
Message-ID: <CAPcyv4gY9fU-T0V0kJBOU9RzCVaagF5NnrDbkyLUJ9iuMdfuOg@mail.gmail.com>
References: <20171011200603.27442-1-jack@suse.cz> <20171011200603.27442-2-jack@suse.cz>
 <20171013071203.GA9105@infradead.org> <1507996677.21357.1.camel@intel.com>
 <20171016074504.GA7316@infradead.org> <20171017115047.GD24136@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "hch@infradead.org" <hch@infradead.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>, "arnd@arndb.de" <arnd@arndb.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:51353 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759579AbdJQTiP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 17 Oct 2017 15:38:15 -0400
Received: by mail-oi0-f53.google.com with SMTP id j126so5017943oib.8
        for <linux-ext4@vger.kernel.org>; Tue, 17 Oct 2017 12:38:15 -0700 (PDT)
In-Reply-To: <20171017115047.GD24136@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 17, 2017 at 4:50 AM, Jan Kara <jack@suse.cz> wrote:
> On Mon 16-10-17 00:45:04, Christoph Hellwig wrote:
>> > How about the following incremental update? It allows ->mmap_validate()
>> > to be used as a full replacement for ->mmap() and it limits the error
>> > code freedom to a centralized mmap_status_errno() routine:
>>
>> Nah - my earlier comment was simply misinformed because I didn't
>> read the whole patch and the _validate name mislead me.
>>
>> So I think the current calling conventions are ok, I'd just like a
>> better name (mmap_flags maybe?) and avoid the need the file system
>> also has to implement ->mmap.
>
> OK, I can do that. But I had just realized that if MAP_DIRECT isn't going
> to end up using mmap(2) interface but something else (and I'm not sure
> where discussions on this matter ended), we don't need flags argument for
> ->mmap at all. MAP_SYNC uses a VMA flag anyway and thus it is fine with the
> current ->mmap interface. We still need some opt-in mechanism for
> MAP_SHARED_VALIDATE though (probably supported mmap flags as Dan had in one
> version of his patch). Thoughts on which way to go for now?

The "supported mmap flags" approach also solves the problem you raised
about MAP_SYNC being silently accepted by an ->mmap() handler that
does not know about the new flag. I.e. leading userpace to potentially
assume an invalid data consistency model. I'll revive that approach
now that the MAP_DIRECT problem is going to be solved via a different
interface.
