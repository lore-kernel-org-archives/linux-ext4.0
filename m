From: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: ext2_block_alloc_info
Date: Tue, 23 Dec 2008 12:27:42 +0800
Message-ID: <804dabb00812222027h4c2b3062i8d00bcfb9e787e54@mail.gmail.com>
References: <2d08ef090812200743o47cd4abdwd9915653f6f4f3f7@mail.gmail.com>
	 <804dabb00812201725r304bed36ufc56ebc2393e2299@mail.gmail.com>
	 <170fa0d20812221856j4c660384nc2ac693ca8fd0ba4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_Part_71855_20612993.1230006462946"
Cc: "Rohit Sharma" <imreckless@gmail.com>,
	Kernelnewbies <kernelnewbies@nl.linux.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Mike Snitzer" <snitzer@gmail.com>
Return-path: <kernelnewbies-bounce@nl.linux.org>
In-Reply-To: <170fa0d20812221856j4c660384nc2ac693ca8fd0ba4@mail.gmail.com>
Sender: kernelnewbies-bounce@nl.linux.org
Errors-to: kernelnewbies-bounce@nl.linux.org
List-help: <mailto:ecartis@nl.linux.org?Subject=help>
List-unsubscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=unsubscribe>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=subscribe>
List-owner: <mailto:ecartis-owner@nl.linux.org>
List-post: <mailto:kernelnewbies@nl.linux.org>
List-archive: <http://mail.nl.linux.org/kernelnewbies/>
List-Id: linux-ext4.vger.kernel.org

------=_Part_71855_20612993.1230006462946
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

anyone knows any way of enumerating all the low level information like these
for each file?

Best I can get is "debugfs":

So using "show_inode_infor xxxx":

Inode: 1146884   Type: regular    Mode:  0767   Flags: 0x0   Generation:
4262211373
User:     0   Group:     0   Size: 4670783
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 9152
Fragment:  Address: 0    Number: 0    Size: 0
ctime: 0x46db7fb6 -- Mon Sep  3 11:29:58 2007
atime: 0x47c66735 -- Thu Feb 28 15:48:05 2008
mtime: 0x43118298 -- Sun Aug 28 17:23:36 2005
BLOCKS:
(0-11):2317946-0, (IND):2317958, (12-1035):2317959-0, (DIND):2318983,
(IND):2318984, (1036-1140):2318985-0
TOTAL: 1144

Here the "BLOCKS" correspond to the block numbering we are talking about,
right?   It always start at 0 per-file.   "IND" is the indirect block.   But
what is "DIND"?   "2317946" is the physical block number right?   And what
is the zero after the "2317946"?

On Tue, Dec 23, 2008 at 10:56 AM, Mike Snitzer <snitzer@gmail.com> wrote:

> On Sat, Dec 20, 2008 at 8:25 PM, Peter Teoh <htmldeveloper@gmail.com>
> wrote:
> > On Sat, Dec 20, 2008 at 11:43 PM, Rohit Sharma <imreckless@gmail.com>
> wrote:
> >> A little confusion.
> >>
> >> Just refer this structure in linux/ext2_fs_sb.h
> >>
> >> struct ext2_block_alloc_info {
> >>  46        /* information about reservation window */
> >>  47        struct ext2_reserve_window_node rsv_window_node;
> >>  48        /*
> >>  49         * was i_next_alloc_block in ext2_inode_info
> >>  50         * is the logical (file-relative) number of the
> >>  51         * most-recently-allocated block in this file.
> >>  52         * We use this for detecting linearly ascending allocation
> requests.
> >>  53         */
> >>  54        __u32                   last_alloc_logical_block;
> >
> > if i interpret the meaning of "file-relative logical number"
> > correctly, and since one-file-one-inode concept, then it means that it
> > should mean inode-relative logical block number.
> >
> >>  55        /*
> >>  56         * Was i_next_alloc_goal in ext2_inode_info
> >>  57         * is the *physical* companion to i_next_alloc_block.
> >>  58         * it the the physical block number of the block which was
> >
> >> inode1 has logical blocks 0 1 2 , physical 22 23 24
> >> inode2 has logical blocks 0 1 2 , physical 34 35 50
> >>
> >
> > as per comment above, the sequence above looks likely, but then this
> > is my guess again.
>
> You are correct.  last_alloc_logical_block is used to detect if the
> write workload against a given inode is sequential (the current
> logical block is last_alloc_logical_block+1).
>
> Mike
>



-- 
Regards,
Peter Teoh

Ernest Hemingway - "Never mistake motion for action."

------=_Part_71855_20612993.1230006462946
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

anyone knows any way of enumerating all the low level information like these for each file?&nbsp; <br><br>Best I can get is &quot;debugfs&quot;:<br><br>So using &quot;show_inode_infor xxxx&quot;:<br><br>Inode: 1146884&nbsp;&nbsp; Type: regular&nbsp;&nbsp;&nbsp; Mode:&nbsp; 0767&nbsp;&nbsp; Flags: 0x0&nbsp;&nbsp; Generation: 4262211373<br>
User:&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; Group:&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; Size: 4670783<br>File ACL: 0&nbsp;&nbsp;&nbsp; Directory ACL: 0<br>Links: 1&nbsp;&nbsp; Blockcount: 9152<br>Fragment:&nbsp; Address: 0&nbsp;&nbsp;&nbsp; Number: 0&nbsp;&nbsp;&nbsp; Size: 0<br>ctime: 0x46db7fb6 -- Mon Sep&nbsp; 3 11:29:58 2007<br>atime: 0x47c66735 -- Thu Feb 28 15:48:05 2008<br>
mtime: 0x43118298 -- Sun Aug 28 17:23:36 2005<br>BLOCKS:<br>(0-11):2317946-0, (IND):2317958, (12-1035):2317959-0, (DIND):2318983, (IND):2318984, (1036-1140):2318985-0<br>TOTAL: 1144<br><br>Here the &quot;BLOCKS&quot; correspond to the block numbering we are talking about, right?&nbsp;&nbsp; It always start at 0 per-file.&nbsp;&nbsp; &quot;IND&quot; is the indirect block.&nbsp;&nbsp; But what is &quot;DIND&quot;?&nbsp;&nbsp; &quot;2317946&quot; is the physical block number right?&nbsp;&nbsp; And what is the zero after the &quot;2317946&quot;?<br>
<br><div class="gmail_quote">On Tue, Dec 23, 2008 at 10:56 AM, Mike Snitzer <span dir="ltr">&lt;<a href="mailto:snitzer@gmail.com">snitzer@gmail.com</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<div><div></div><div class="Wj3C7c">On Sat, Dec 20, 2008 at 8:25 PM, Peter Teoh &lt;<a href="mailto:htmldeveloper@gmail.com">htmldeveloper@gmail.com</a>&gt; wrote:<br>
&gt; On Sat, Dec 20, 2008 at 11:43 PM, Rohit Sharma &lt;<a href="mailto:imreckless@gmail.com">imreckless@gmail.com</a>&gt; wrote:<br>
&gt;&gt; A little confusion.<br>
&gt;&gt;<br>
&gt;&gt; Just refer this structure in linux/ext2_fs_sb.h<br>
&gt;&gt;<br>
&gt;&gt; struct ext2_block_alloc_info {<br>
&gt;&gt; &nbsp;46 &nbsp; &nbsp; &nbsp; &nbsp;/* information about reservation window */<br>
&gt;&gt; &nbsp;47 &nbsp; &nbsp; &nbsp; &nbsp;struct ext2_reserve_window_node rsv_window_node;<br>
&gt;&gt; &nbsp;48 &nbsp; &nbsp; &nbsp; &nbsp;/*<br>
&gt;&gt; &nbsp;49 &nbsp; &nbsp; &nbsp; &nbsp; * was i_next_alloc_block in ext2_inode_info<br>
&gt;&gt; &nbsp;50 &nbsp; &nbsp; &nbsp; &nbsp; * is the logical (file-relative) number of the<br>
&gt;&gt; &nbsp;51 &nbsp; &nbsp; &nbsp; &nbsp; * most-recently-allocated block in this file.<br>
&gt;&gt; &nbsp;52 &nbsp; &nbsp; &nbsp; &nbsp; * We use this for detecting linearly ascending allocation requests.<br>
&gt;&gt; &nbsp;53 &nbsp; &nbsp; &nbsp; &nbsp; */<br>
&gt;&gt; &nbsp;54 &nbsp; &nbsp; &nbsp; &nbsp;__u32 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; last_alloc_logical_block;<br>
&gt;<br>
&gt; if i interpret the meaning of &quot;file-relative logical number&quot;<br>
&gt; correctly, and since one-file-one-inode concept, then it means that it<br>
&gt; should mean inode-relative logical block number.<br>
&gt;<br>
&gt;&gt; &nbsp;55 &nbsp; &nbsp; &nbsp; &nbsp;/*<br>
&gt;&gt; &nbsp;56 &nbsp; &nbsp; &nbsp; &nbsp; * Was i_next_alloc_goal in ext2_inode_info<br>
&gt;&gt; &nbsp;57 &nbsp; &nbsp; &nbsp; &nbsp; * is the *physical* companion to i_next_alloc_block.<br>
&gt;&gt; &nbsp;58 &nbsp; &nbsp; &nbsp; &nbsp; * it the the physical block number of the block which was<br>
&gt;<br>
&gt;&gt; inode1 has logical blocks 0 1 2 , physical 22 23 24<br>
&gt;&gt; inode2 has logical blocks 0 1 2 , physical 34 35 50<br>
&gt;&gt;<br>
&gt;<br>
&gt; as per comment above, the sequence above looks likely, but then this<br>
&gt; is my guess again.<br>
<br>
</div></div>You are correct. &nbsp;last_alloc_logical_block is used to detect if the<br>
write workload against a given inode is sequential (the current<br>
logical block is last_alloc_logical_block+1).<br>
<font color="#888888"><br>
Mike<br>
</font></blockquote></div><br><br clear="all"><br>-- <br>Regards,<br>Peter Teoh<br><br>Ernest Hemingway - &quot;Never mistake motion for action.&quot;<br>

------=_Part_71855_20612993.1230006462946--

--
To unsubscribe from this list: send an email with
"unsubscribe kernelnewbies" to ecartis@nl.linux.org
Please read the FAQ at http://kernelnewbies.org/FAQ
