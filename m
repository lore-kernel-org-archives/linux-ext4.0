From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 01/19] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Date: Fri, 13 Oct 2017 11:28:40 -0700
Message-ID: <CAPcyv4iOwkOrF2mc-v43poCx8B3kV0Cdrq6e33ZBnD5NesKKew@mail.gmail.com>
References: <20171011200603.27442-1-jack@suse.cz> <20171011200603.27442-2-jack@suse.cz>
 <20171013071203.GA9105@infradead.org> <CAPcyv4hYuL-wOu7oBt5P=pj8rSnwudNEzRdqswaOhMN0QvN1yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ted Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:43190 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752693AbdJMS2l (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Oct 2017 14:28:41 -0400
Received: by mail-oi0-f45.google.com with SMTP id c77so15626433oig.0
        for <linux-ext4@vger.kernel.org>; Fri, 13 Oct 2017 11:28:40 -0700 (PDT)
In-Reply-To: <CAPcyv4hYuL-wOu7oBt5P=pj8rSnwudNEzRdqswaOhMN0QvN1yg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 13, 2017 at 8:44 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Oct 13, 2017 at 12:12 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> So did we settle on the new mmap_validate vs adding a new argument
>> to ->mmap for real now?  I have to say I'd much prefer passing an
>> additional argument instead, but if higher powers rule that out
>> this version is ok.
>
> MAP_DIRECT also needs the fd now, so it would be two arguments. Before
> you say "that's bogus" I want to understand what the alternative looks
> like for notifying userspace that its get_user_pages() registration
> lease is being invalidated.
>

Jason straightened me out about how RDMA applications expect to get
notifications and now I see why the fd based scheme is lacking.
