From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH v2] ext4: have ext4_xattr_set_handle() allocate journal credits
Date: Tue, 4 Jul 2017 00:23:13 -0700
Message-ID: <CAAeU0aOGYZ-55Z2xMgHZ-02wap6Mzby3MxQaAAZSeHuLB-9JHw@mail.gmail.com>
References: <20170629005029.13302-1-tahsin@google.com> <20170629030618.5101-1-tahsin@google.com>
 <18BC3861-631F-4C45-9043-14E92B3D7922@dilger.ca> <CAAeU0aMSi0A_jAkzDwP6t_TApBwkjMHydxKXfnoK+ojMSxyC=A@mail.gmail.com>
 <20170704054839.y2k2yxcjmh6b5jt4@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Ts'o" <tytso@mit.edu>,
        Tahsin Erdogan <tahsin@google.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170704054839.y2k2yxcjmh6b5jt4@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> Are you aware of other cases where we're likely to run into problems
> besides ext4_new_inode()?

Nope. If we can get ext4_new_inode() case covered we should be fine.

I will abandon this patch and will work on a patch that adds extra
credits in __ext4_new_inode().

thanks
