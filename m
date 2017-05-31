From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 09/28] ext4: extended attribute value size limit is
 enforced by vfs
Date: Wed, 31 May 2017 09:13:35 -0700
Message-ID: <CAAeU0aMboDdSD9gdkscDU6jGEB1bV6AFCW+FqHz9XjuQcH1Arw@mail.gmail.com>
References: <20170531081517.11438-1-tahsin@google.com> <20170531081517.11438-9-tahsin@google.com>
 <20170531160353.GH4510@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Jan Kara <jack@suse.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170531160353.GH4510@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Darrick,

>> -#define EXT4_XATTR_MAX_LARGE_EA_SIZE    (1024 * 1024)
>
> Uhhh... didn't you add this in patch 1/28?  There's little point in
> adding a symbol just to delete it shortly thereafter.
>
1/28 is the original patch I've received from Andreas. I wanted to
leave his patch in its original form as much as possible so that the
modifications I made on them are clear. If preferred, I can squash
them later, but I thought it is a little clearer this way.
