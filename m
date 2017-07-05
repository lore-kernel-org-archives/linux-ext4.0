From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [proposal] making filesystem tools more machine friendly
Date: Wed, 5 Jul 2017 11:11:13 -0700
Message-ID: <20170705181113.GA20326@infradead.org>
References: <CACj3i70p=ybXZWRncseqwnbs7HAYu-SL02+cj--7T5YnqcwVKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs <linux-xfs@vger.kernel.org>
To: Jan Tulak <jtulak@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACj3i70p=ybXZWRncseqwnbs7HAYu-SL02+cj--7T5YnqcwVKQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jan,

I really like the idea out json output for fs/block tools.

nvme-cli has been doing it for a while, and that has been very
useful.  It comes with it's own little handrolled json output
helpers:

	https://github.com/linux-nvme/nvme-cli/blob/master/json.c

so it doesn't introduce any new dependencies.  If you want to parse
input as well a library might be a better approach, though.

I really don't like the shared object evms model mention in the thread,
as that creates hard ELF dependencies.
