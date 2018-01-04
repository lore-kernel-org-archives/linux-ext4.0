From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 00/18] dax: fix dma vs truncate/hole-punch
Date: Thu, 4 Jan 2018 09:17:55 +0100
Message-ID: <20180104081755.GD2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, Michal Hocko <mhocko@suse.com>,
        jack@suse.cz, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, hch@lst.de,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-fsdevel@vger.kernel.org,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        linux-nvdimm@lists.01.org, Theodore Ts'o <tytso@mit.edu>,
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> So far this solution only targets xfs since it already implements
> xfs_break_layouts in all the locations that would need this
> synchronization. It applies on top of the vmem_altmap / dev_pagemap
> reworks from Christoph.

Those got a rebase since your posting of this series, btw.
